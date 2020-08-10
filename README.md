# FPSlicer
A proof-of-concept first-person 3d printer slicer for virtual reality

To start, I should say, this is not a proper 3d printer slicer.  I never coded the slicing functionality and probably never will.  Currently, the software can only load an STL model and drop it to the build plate.  

The purpose of this project was to evaluate the Godot game engine and find out if it is suitable for making a professional-grade GUI for graphics intensive engineering software.  I expected a no-go.  Surprisingly, it passed my tests with a few caveats.

Advantages:
1. Great-looking 3D graphics without fighting with OpenGL
2. A GUI with a decent amount of ready-made controls and easy extensibility
3. Ability to run on Linux, Mac, Windows, Web, VR/AR, etc.
4. Godot's core and utility libraries with XML, zip, etc.
5. GUI can be made in a scripting language (gdscript), which to me is natural for a GUI.
6. Scripted GUI code is encrypted during build process for commercial protection.
7. Computationally intensive algorithms can be written in C/C++, which to me is more natural.
8. BEST OF ALL: It is pretty easy to do creative things with your UI.  In this case, the first-person carries a tablet device with a viewport pane, and the GUI resides there.  This way you can walk around the 3d print room in virtual reality and operate controls on your virtual tablet.

Disadvantages:
1. The GUI gets pixelated once you stick it in the tablet viewport.  Thus creative ideas are subject to some limitations.  I do not have VR googles, but I am curious how pixelated it would look in the VR world.
2. It seems difficult to make a very professional/commercial looking GUI of the type Qt provides.  I am sure with Godot themes that anything is possible.  But it is a question of how much effort it takes to get there.

Here is a screenshot of FPSlicer running on a desktop computer.  The tablet in the left half of the view window moves with the first-person.  First-person movement is controlled with arrow keys.

![FPSlicer](https://github.com/scline6/FPSlicer/edit/master/FPSlicerDemoImage1.png?raw=true)
