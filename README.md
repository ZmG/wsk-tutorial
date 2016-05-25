Whisk Tutorial
===============

The Whisk tutorial is an interactive learning environment to get familiar with the whisk commandline.


Development Guide:
==================
This is a two part application:      

1. trywsk: the base page that serves as a catalog for the tutorials. (https://github.com/ZmG/trywsk)   
2. wsk-tutorial: the tutorials. (https://github.com/ZmG/wsk_tutorial)  

To run the application on Bluemix, call the following from trywsk directory:    
`cf push`

This will download all the dependencies from requirements.txt including this tutorial.
Everytime you want to update something, make sure to re-run this command and ensure any changes made to 
the tutorial have been committed to the repo: https://github.com/ZmG/wsk_tutorial


Install dev tools:
-------------------------------
install coffee-script: `npm install -g coffee-script`


Adding/Updating steps
-------------------------------
All the steps are stored in arrays. The basic tutorial is stored in 'q' while the advanced tutorial
is stored in 'adv_q' both of which can be found in steps.coffee. If you follow the pattern in the steps.coffee 
file it should be fairly trivial to figure out how to modify a question. When steps.cofee is modified you
will need to compile the .coffee files to javascript file. For this you will need to have coffee-script 
installed on your computer. see "Install dev tools" section above. 

1. Open the steps.coffee file that is located in wsk_tutorial/static/js directory.
2. Locate the corresponding queue to which you'd like add a step to. For example, trigger_q holds all the step items for the trigger tutorial. 
3. Push a new item to the corresponding q. You can reuse the structure from previous steps.   
   Example: trigger_q.push({...})

compilation command: `coffee -c steps.coffee`
this will generate the steps.js file.

Updating the wsk cli interpreter
--------------------------------
The interpreter is written in terminal.coffee, in the 'wsk' function. The entire thing is really a giant set of 
if else statements. The logic flow is pretty straight forward. To generate the js files, run the following:

1. Open the terminal.coffee file that is located in the wsk_tutorial/static/js directory.
2. Adding a new command to the interpreter:    
  1. Locate "WSK Interpreter" comment block    
  2. Add a new if clause to the wsk if-else code block and echo to the corresponding variable holding the content for the output   
  3. Adding content for the output of a command:  
     a. Locate "WSK Content" comment block.   
     b. Create a new variable holding the output content for the command to be added.   
3. Compile the terminal.coffee file:   
    a. `coffee -c terminal.coffee` 


Styling
--------------------------------
Styling can be found in the tutorial-style.css file.

Happy coding!

