extends Node

var player: CharacterBody2D = null
var world: Node2D = null
var spikes: Node2D = null
var tilemap: TileMap = null
var camera: Camera2D = null

var graves: Array[Vector2i]
var enemy_count = 0
