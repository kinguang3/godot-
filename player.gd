extends Area2D
signal hit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var speeed = 400  # 注意：变量名拼写为"speeed"，建议改为"speed"
var screen_size: Vector2

func _ready() -> void:
	hide()
	# 等待一帧确保视口已初始化
	await get_tree().process_frame
	screen_size = get_viewport_rect().size
	# 或者可以设置一个最小边界
	if screen_size == Vector2.ZERO:
		screen_size = Vector2(1152, 648)  # 默认大小

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	# 获取输入
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1  # 注意：Godot中y轴向下为正
	if Input.is_action_pressed("move_down"):
		velocity.y += 1  # 这里原来是错误的
	
	# 归一化并应用速度
	if velocity.length() > 0:
		velocity = velocity.normalized()  # 这里也可以乘以速度
		animated_sprite_2d.play()
	else:
		animated_sprite_2d.stop()
	
	# 移动玩家
	position += velocity * delta * speeed  # 注意：上面已经乘过速度了，这里就不需要再乘
	
	# 限制在屏幕内
	if screen_size != Vector2.ZERO:
		position = position.clamp(Vector2.ZERO, screen_size)
	
	# 动画控制
	update_animation(velocity)

func update_animation(velocity: Vector2) -> void:
	if velocity.x != 0:
		animated_sprite_2d.animation = "walk"
		animated_sprite_2d.flip_v = false
		animated_sprite_2d.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite_2d.animation = "up"
		# 对于上下动画，你可能想要不同的逻辑
		# animated_sprite_2d.flip_h = velocity.y > 0  # 这行可能需要调整
	
	# 简化版本 - 直接根据x速度设置翻转
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false
	if velocity.y > 0:
		animated_sprite_2d.flip_v = true
	elif velocity.y	< 0:
		animated_sprite_2d.flip_v = false	

func _on_body_entered(body: Node2D) -> void:
	hide()#如果该 CanvasItem 目前是可见的，则将其隐藏。相当于将 visible 设为 false。
	hit.emit()
	collision_shape_2d.set_deferred("disabled", true)

func start(pos: Vector2) -> void:
	position = pos
	show()
	collision_shape_2d.disabled = false
