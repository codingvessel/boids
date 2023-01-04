extends Node2D


var Boid:PackedScene = preload("res://boid.tscn")

var velocity
var amount = 100
var speed = 8000



# Called when the node enters the scene tree for the first time.
func _ready():
	for x in amount:
		var boid = Boid.instantiate()
		boid.position = Vector2(randf_range(-10000,10000),randf_range(-10000,10000))
		boid.rotation = randf_range(0,6.28)
		get_tree().get_current_scene().add_child(boid)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for boid in get_tree().get_nodes_in_group("boids"):
		var cohesion_vec:Vector2
		var allignment_vec:Vector2
		var seperation_vec:Vector2
		var velocity = boid.transform.y * -1 * speed
		
		cohesion_vec = cohesion_rule(boid)
		seperation_vec = seperation_rule(boid)
		allignment_vec = allignment_rule(boid)
		
		
		velocity = velocity + cohesion_vec + allignment_vec + seperation_vec
		boid.velocity = velocity
		boid.look_at(boid.velocity)
		boid.position += boid.velocity * delta 
		

func cohesion_rule(individual_boid) -> Vector2:
	var perceived_centre:Vector2
	
	for boid in get_tree().get_nodes_in_group("boids"):
		if boid != individual_boid:
			perceived_centre = perceived_centre + boid.position
	
	perceived_centre = perceived_centre / (amount-1)
	
	return (perceived_centre-individual_boid.position) / 10
	

func seperation_rule(individual_boid) -> Vector2:
	var seperation_vec:Vector2
	
	for boid in get_tree().get_nodes_in_group("boids"):
		if boid != individual_boid:
			if (boid.position - individual_boid.position).length() < 150:
				seperation_vec = seperation_vec - (boid.position - individual_boid.position)
	
	return seperation_vec
	
func allignment_rule(individual_boid) -> Vector2:
	var perceived_velocity:Vector2
	
	for boid in get_tree().get_nodes_in_group("boids"):
		if boid != individual_boid:
			perceived_velocity = perceived_velocity + boid.velocity
	
	perceived_velocity = perceived_velocity / (amount-1)
	
	return (perceived_velocity-individual_boid.velocity) / 2
