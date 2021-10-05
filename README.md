# GodotDumbCustomResourceTypes
A really smooth-brained solution for custom resource type exports in Godot Engine

## Story
I used Godot 3.4 for competing in Ludum Dare 39. It was a pain to deal with using custom resource types in the editor because, at the moment, GDScript doesn't allow for exporting as a custom resource type. I knew that if I wanted to keep making games in Godot, especially for game jams, I needed a solution. I spent maybe half an hour on this solution, but it works well enough for small games and situations where you need your custom resources accessible

## Pros and Cons

| Pros | Cons|
|---|---|
|All of your custom resources are pushed to the top of the list when creating a new resource instance|This is accomplished by registering all custom resources with a prefix of "AAA_"|
|Your resources are easy to find quickly|Sometimes Godot doesn't differentiate and your custom resources will appear on every possible new resource menu, whether or not it makes sense|

## How to use
So, you read through the pros and cons and _still_ want to use this half-baked solution in your project!?!

~~why would you ever???~~ EXCELLENT DECISION!
### Steps
1. Download this code as a ZIP archive
2. Extract the addons folder from that archive into your Godot 3.4 project
3. In Godot navigate : Project -> Project Settings...
4. Go to the "Plugins" tab
5. Click on "Enable" for the "CustomResourceExports" plugin listed
    * If it is not there, make sure the folder "custom_exports" is under the "addons" folder in the root of your project folder
