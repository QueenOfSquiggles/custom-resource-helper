tool
extends Control
class_name ResourceManagerMenu

# setting a custom prfix for all custom resources makes the resources appear at the top of the list for making a new resource
const CUSTOM_RESOURCE_PREFIX := "AAA_"

const USE_DEBUG_PRINT := true # set to false to stop printing info

const RESOURCE_PATH := "res://addons/custom_exports/resource_scripts/"
const FALLBACK_ICON := preload("res://addons/custom_exports/custom_resource_default.png")
var _registered_types := []

var plugin_instance : EditorPlugin

onready var types_list := $HBoxContainer/PanelContainer/VBoxContainer/types_panel/TypesList



func load_resource_types() -> void:
	if not plugin_instance:
		print("No plugin instance assigned!")
		return
	var files := _get_all_resource_files()
	if files.empty():
		return
	for f in files:
		_add_resource(f)
	if USE_DEBUG_PRINT:
		print("Loaded resource type(s) :  ", _registered_types)
	_refresh_type_list()

func _add_resource(file : String) -> void:
	var script : Resource = load(RESOURCE_PATH + file)
	var name :String = file.split(".")[0]
	var icon := _load_icon(name)
	# add it after loading the icon so we can have script & icon pairs
	name = CUSTOM_RESOURCE_PREFIX + name
	plugin_instance.add_custom_type(name, "Resource", script, icon)

	_registered_types.append(name)


func _load_icon(name : String) -> Texture:
	var f := File.new()
	var gen_path := RESOURCE_PATH + name + ".png"
	if f.file_exists(gen_path):
		return load(gen_path) as Texture
	elif USE_DEBUG_PRINT:
		# just let the user know that this resource will be using the default icon
		print("Using fallback icon for %s, create a PNG named the same as the file for applying a custom icon. expected path : \"%s.png\"" % [name, gen_path])
	return FALLBACK_ICON


func remove_resource_types() -> void:
	if USE_DEBUG_PRINT:
		print("Removing resource type(s) : ", _registered_types)

	for r in _registered_types:
		plugin_instance.remove_custom_type(r)
	_registered_types.clear()
	_refresh_type_list()

func _get_all_resource_files() -> Array:
	var files := []
	var dir = Directory.new()
	dir.open(RESOURCE_PATH)
	dir.list_dir_begin()
	while true:
		var file :String = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".gd"):
			# file is a gdscript file
			var res : Resource = load(RESOURCE_PATH + file)
			if res:
				# script is a Resource
				files.append(file)
			else:
				# A script that is not a resource is in the folder!
				# That should not happen!
				print("failed to load from %s" % file)
	dir.list_dir_end()
	return files

func _refresh_type_list() -> void:
	for c in types_list.get_children():
		(c as Node).queue_free()
	for t in _registered_types:
		var label := Label.new()
		var stripped = (t as String).split("_", true, 1)[1]
		label.text = stripped
		types_list.add_child(label)


func _on_Btn_ReloadAllResources_pressed() -> void:
	# clear all types
	remove_resource_types()
	# add all types
	load_resource_types()


func _on_Btn_UnloadAllResources_pressed() -> void:
	remove_resource_types()


func _on_Btn_LoadAllResources_pressed() -> void:
	if _registered_types.empty():
		# don't load unless no resources are currently registered
		load_resource_types()
