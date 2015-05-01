###
  This is the main script file. It can attach to the terminal
###

COMPLETE_URL = "/whats-next/"


###
  Array of question objects
###

staticDockerPs = """
    ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS
    """



q = []
q.push ({
html: """
      <h3>Getting started</h3>
      <p>Use IBM® Containers to run Docker containers in a hosted cloud environment on IBM Bluemix™. IBM Containers 
      helps you build and deploy containers where you can package your applications and services. Each container is 
      based on an image format, includes a set of standard operations, and is an execution environment in itself.
      </p>
      <p>If you are familiar with Docker CLI, then the first half of this tutorial will show you how to use common docker 
      commands using ice --local. This CLI Has disabled docker commands. If you want to use a docker command you must use
      <code>ice --local</code>. 'ice --local' is equivalent to 'docker'</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Use ice commands to check the current ice (IBM Containers Extension) CLI version you are running.</p>
      <p>If you see a version value then you know you that your all set with your ice client installation. The ice CLI is supported on Linux OS.
      For Windows, your best option is to create an Ubuntu VM and install your client software there.</p>
      """
intermediateresults: [
  () -> """<p>Use version instead of --version</p>"""
  ]
tip: "<p>Try typing <code>ice --help</code> to see the full list of accepted arguments</p>
      <p>This emulator provides only a limited set of shell and ice commands, so some commands may not work as expected</p>"
command_expected: ['ice', 'version']
result: """<p>Well done! Let's move to the next assignment.</p>"""
})

q.push ({
html: """
      <h3>Logging In</h3>
      <p>The easiest way to get started is to log in to the IBM Containers infrastructure.  For details on login arguments, search the online 
      <a href="#1" onClick="window.open('https://www.ng.bluemix.net/docs/#starters/index-gentopic3.html#genTopProcId4','IBM Containers Doc','width=1000,height=900,left=50,top=50,menubar=0')";>IBM Containers Doc</a>
      and by using the commandline</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Use the <code>ice login</code> command to log in to the IBM Containers infrastructure. Ice will ask you for a username and password, any value will work.</p>
      """
command_expected: ['ice', 'login']
result: """<p>You found it! Way to go!</p>"""
tip: "the optional arguments for login are specified in the online Bluemix Containers doc"
})

q.push ({
html: """
      <h3>Downloading container images</h3>
      <p>This exercise will introduce the <b>--local</b> tag. calling ice --local is the same as calling docker. ice --local will pass arguements to docker and run like standard docker.</p>
      <p>Container images can be downloaded just as easily, using <code>docker pull</code>.</p>
      <p>However, instead of calling <code>docker pull</code> directly we will use <code>ice --local pull</code>, to pull images from registry-ice.ng.bluemix.net/&lt;Namespace&gt;/&lt;Image&gt;.</p>
      <p>For images from your namespace index, the name you specify is constructed as &lt;Namespace&gt;/&lt;Image Name&gt;</p>
      <p>A group of special, trusted images such as the ibmnode image can be retrieved by just their name registry-ice.ng.bluemix.net/&lt;Image Name&gt;.</p>
      """
assignment:
      """
      <h3>Assignment</h3>
      <p>Pull the trusted <b>'ibmnode'</b> image from the <b>'registry-ice.ng.bluemix.net/'</b> Registry.</p>
      """
command_expected: ['ice', '--local', 'pull', 'registry-ice.ng.bluemix.net/ibmnode']
result: """<p>Cool. Look at the results. You'll see that ice has invoked docker to download a number of layers. In Docker all images (except the base image) are made up of several cumulative layers.</p>"""
intermediateresults: [
  () -> """<p>You seem to be almost there. Don't forget to tell <b>ice --local pull</b> where to find the image, ice --local pull &lt;<Registry url>&gt;/&lt;learn&gt;/&lt;tutorial&gt; """,
  () -> """<p>You got the namespace and image name correct, but forgot to specify a registry, hint ice --ltiyu5ocal pull &lt;Registry url&gt;/Image Name&gt;</p>"""
  () -> """<p>Looks like you forgot to use the --local flag, try <em>ice --local pull [registry/namespace/imageName]</em></p>"""
  ]
tip: """
    <ul>
      <li>The ibmnode image is a trusted image. Therefore you do not have to specify a namespace.</li>
      <li>For this tutorial the namespace for your registry will always be <b>'learn'</b></li>
      <li>Look under 'show expected command if you're stuck.</li>
    </ul>
     """
currentLocalImages :
  """
  REPOSITORY                              TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
    
  ubuntu                                  latest              8dbd9e392a96        4 months ago         131.5 MB (virtual 131.5 MB)
  registry-ice.ng.bluemix.net/ibmnode     latest              8dbd9e392a96        2 months ago         131.5 MB (virtual 131.5 MB)
  """
})


q.push ({
html: """
      <h3>Hello world from a container</h3>
      <p>You can think about containers as a process in a box. The box contains everything the process might need, so
      it has the filesystem, system libraries, shell and such, but by default none of it is started or run.<p>
      <p>You 'start' a container <em>by</em> running a process in it. This process is the only process run, so when
      it completes the container is fully stopped.
      """
assignment: """
      <h3>Assignment</h3>
      <p>Make our freshly loaded container image output "hello world"</p>
      <p>To do so you should run 'echo' in the container and have that say "hello world"

      """
command_expected: ["ice", "--local", "run", "registry-ice.ng.bluemix.net/ibmnode", "echo", "hello"]
command_show: ["ice", "--local", "run", "registry-ice.ng.bluemix.net/ibmnode", 'echo "hello world"']

result: """<p>Great! Hellooooo World!</p><p>You have just started a container and executed a program inside of it, when
        the program stopped, so did the container."""
intermediateresults: [
  () -> """<p>You seem to be almost there. Did you give the command `echo "hello world"` """,
  () -> """<p>You've got the arguments right. Did you get the command? Try <em>/bin/bash </em>?</p>"""
  ]
tip: """
  <ul>
     <li>The command <code>ice --local run</code> takes a minimum of two arguments. An image name, and the command you want to execute
     within that image.</li>
     <li>Check the expected command below if it does not work as expected.</li>
     <li>Remember the image name is registry-ice.ng.bluemix.net/ibmnode  </li>
  </ul>
    """
currentLocalImages :
  """
  REPOSITORY                              TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
    
  ubuntu                                  latest              8dbd9e392a96        4 months ago         131.5 MB (virtual 131.5 MB)
  registry-ice.ng.bluemix.net/ibmnode     latest              8dbd9e392a96        2 months ago         131.5 MB (virtual 131.5 MB)
  """
})

q.push ({
html: """
      <h3>Installing things in the container</h3>
      <p>Next we are going to install a simple program (ping) in the container. The image is based upon ubuntu, so you
      can run the command <code>apt-get install -y iputils-ping</code> in the container. </p>
      <p>Note that even though the container stops right after a command completes, the changes are not forgotten.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Install 'iputils-ping' on top of the registry-ice.ng.bluemix.net/ibmnode image.</p>
      """
command_expected: ["ice", "--local", "run", "registry-ice.ng.bluemix.net/ibmnode", "apt-get", "install", "-y", "iputils-ping"]
command_show: ["ice", "--local", "run", "registry-ice.ng.bluemix.net/ibmnode", "apt-get", "install", "-y", "iputils-ping"]
result: """<p>That worked! You have installed a program on top of a base image. Your changes to the filesystem have been
        kept, but are not yet saved.</p>"""
intermediateresults: [
  () -> """<p>Not specifying -y on the apt-get install command will work for ping, because it has no other dependencies, but
  it will fail when apt-get wants to install dependencies. To get into the habit, please add -y after apt-get.</p>""",
]
tip: """
     <p>Don't forget to use -y for noninteractive mode installation</p>
     <p>Not specifying -y on the apt-get install command will fail for most commands because it expects you to accept
     (y/n) but you cannot respond.
     </p>
     """
})

q.push ({
html: """
      <h3>Save your changes</h3>
      <p>After you make changes (by running a command inside a container), you probably want to save those changes.
      This will enable you to later start from this point onwards.</p>
      <p>With Docker, the process of saving the state is called <em>committing</em>. Commit basically saves the difference
      between the old image and the new state. The result is a new layer.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>First use <code>ice --local ps -l</code> to find the ID of the container you created by installing ping.</p>
      <p>Then save (commit) this container with the repository name 'learn/ping' </p>
      <p>Remember for this tutorial our namespace is <b>learn</b></p>
      """
command_expected: ["ice", "--local", "commit", "698", "learn/ping"]
command_show: ["ice", "--local", "commit", "698", 'learn/ping']
result: """<p>That worked! Please take note that Docker has returned a new ID. This id is the <em>image id</em>.</p>"""
intermediateresults: [ () -> """You have not specified the correct repository name to commit to (learn/ping). This works, but giving your images a name
                      makes them much easier to work with."""]
tip: """<ul>
     <li>Giving just <code>ice --local commit</code> will show you the possible arguments.</li>
     <li>You will need to specify the container to commit by the ID you found</li>
     <li>You don't need to copy (type) the entire ID. Three or four characters are usually enough.</li>
     </ul>"""

currentLocalImages :
  """
  REPOSITORY                              TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
    
  ubuntu                                  latest              8dbd9e392a96        4 months ago         131.5 MB (virtual 131.5 MB)
  registry-ice.ng.bluemix.net/ibmnode     latest              8dbd9e392a96        2 months ago         131.5 MB (virtual 131.5 MB)
  learn/ping                              latest              effb66b31edb        10 minutes ago       11.57 MB (virtual 143.1 MB)
  """
})


q.push ({
html: """
      <h3>Run your new image</h3>
      <p>Now you have basically setup a complete, self contained environment with the 'ping' program installed. </p>
      <p>Your image can now be run on any host that runs Docker.</p>
      <p>Lets run this image on this machine.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Run the ping program to ping localhost</p>

      """
command_expected: ["ice", "--local", "run", 'learn/ping', 'ping', 'localhost' ]
result: """<p>That worked! Note that normally you can use Ctrl-C to disconnect. The container will keep running. This
        container will disconnect automatically.</p>"""
intermediateresults: [ 
    () -> """Usually you would be able to ping other domains, but this emlator only supports localhost."""
  ]
tip: """<ul>
     <li>Make sure to use the learn/ping image to run ping.</li>
     </ul>"""
})




q.push ({
html: """
      <h3>Check your running image</h3>
      <p>You now have a running container. Let's see what is going on.</p>
      <p>Using <code>ice --local ps</code> we can see a list of all running containers, and using <code>ice --local inspect</code>
      we can see all sorts of useful information about this container.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p><em>Find the container id</em> of the running container, and then inspect the container using <em>ice --local inspect</em>.</p>

      """
command_expected: ["ice", "--local", "inspect", "efe" ]
result: """<p>Success! Have a look at the output. You can see the ip-address, status and other information.</p>"""
intermediateresults: 
  [ 
    () -> """You have not specified a repository name. This is not wrong, but giving your images a name make them much easier to work with."""
  ]
tip: """<ul>
     <li>Remember you can use a partial match of the image id, three or more letters should work.</li>
     </ul>"""
currentDockerPs:
    """
    ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS
    efefdc74a1d5        learn/ping:latest   ping localhost        37 seconds ago      Up 36 seconds
    """

})

q.push ({
html: """
      <h3>Tagging your image with ice</h3>
      <p>Now you have verified that your application container works locally, it's time to get it ready for Bluemix.</p>
      <p>Remember you pulled (downloaded) the registry-ice.ng.bluemix.net/ibmnode image from the Bluemix Registry? You can also push (upload) your built images
      to the Registry. That way you can easily retrieve them for re-use and share them with others. </p>

      <p>To use an image on bluemix, you will first need to push the image up to your,
      bluemix registry. To do that we need to tag the pulled image with your namespace and a name, that will identify it in your 
      bluemix registry.
      </p>
      <p>Note: You can also push images downloaded from the <a href="registry.hub.docker.com">Docker Public Registry</a> to your Bluemix Private Registry.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Tag the learn/ping image using <code>ice --local tag</code>. tag the image with the name <b>'learn/ping'</b>. This prepares the image for pushing to the bluemix registry.</p>
      <p>tag usage: <b>'ice --local tag &lt;local_Image_name&gt; registry-ice.ng.bluemix.net/&lt;Namespace&gt;/&lt;Image_name&gt;'</b></p>
      """
command_expected: ["ice", "--local", "tag", "learn/ping", "registry-ice.ng.bluemix.net/learn/ping"]
command_show: ["ice", "--local", "tag", "learn/ping", "registry-ice.ng.bluemix.net/learn/ping"]
result: """<p>Success! The image is now tagged and ready to push. In the next section we'll push to the registry</p>"""
intermediateresults:
  [
    () -> """Almost there, don't forget to provide the name of the local image that will be tagged (learn/ping)"""
    () -> """remember the local image is <b>learn/ping</b> and the tag name will be registry-ice.ng.bluemix.net/learn/ping"""
    () -> """you need to use learn/ping not registry-ice.ng.bluemix.net/ibmnode"""
    () -> """Looks like you did'nt give ice a name to tag the image with, try adding registry-ice.ng.bluemix.net/learn/ping"""
  ]
tip: """
    <ul>
      <li><code>ice images</code> will show you which images are currently on your host</li>
      <li><code>ice --local images</code> will show you which images exist locally (docker)</li>
      <li>For more usage info see the docs <a a href="https://www.ng.bluemix.net/docs/#starters/index-gentopic3.html#container_install">here</a></li>
      <li>You can only push images to your own namespace, this emulator uses the namespace 'learn'</li>
      <li>Click the hint below if you get stuck.</li>
    </ul>
    """
});

q.push ({
html: """
      <h3>Pushing your image to the Bluemix registry</h3>
      <p>Now that our image is commited and tagged, we are ready to push it up to the private bluemix registry.</p>
      <p>To do this we will be using the push command</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Push the <b>learn/ping</b> image up to the public bluemix registry: <b>registry-ice.ng.bluemix.net/learn/ping</b></p>
      """
command_expected: ["ice", "--local", "push", "registry-ice.ng.bluemix.net/learn/ping"]
command_show: ["ice", "--local", "push", "registry-ice.ng.bluemix.net/learn/ping"]
result: """<p>Success! The learn/ping image will now show up in you bluemix registry!</p>"""
intermediateresults:
  [
    () -> """You're pushing up the wrong image, try pushing the image we just tagged <em>registry-ice.ng.bluemix.net/learn/ping</em>"""
  ]
tip: """
    <ul>
    <li>Remember that the namespace is <b>'learn'</b></li>
    <li>For more info on how to specify a target registry, see the <a href="https://www.ng.bluemix.net/docs/#starters/index-gentopic3.html#container_install">docs</a></li>
    </ul>
    """
currentCloudImages :
  """
  Image Id                             Created              Image Name

  662c446b-1c9c-424e-bcb4-61288ceede43 Apr 20 06:21:23 2015 registry-ice.ng.bluemix.net/learn/ping:latest
  d0feae99-b91d-4ce3-bcb4-6128886f6968 Mar 23 10:44:59 2015 registry-ice.ng.bluemix.net/ibmliberty:latest
  74831680-1c9c-424e-b8ea-ceede4aa0e40 Mar 23 10:41:24 2015 registry-ice.ng.bluemix.net/ibmnode:latest
  """
});

q.push ({
html: """
      <h3>Running on Bluemix</h3>
      <p>We are now ready to run our ping container on Bluemix! To do this we will be using <code>ice run</code>.</p>
      <p>The <code>ice run</code> command will need a couple arguements from us. First we will need to give it a name for the new container.
       next we will specify the image that the container will need to run. Finally we will pass a command (ping) that will be run once the container is created.
      </p>
      <p>Note: from here on out we will no longer need to use the <code>--local</code> tag, we will be working exclusively on the cloud.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>create and run a container on bluemix using <code>ice run</code>. The container must have the name <b>'ice-ping'</b>. It will also run our <b>learn/ping</b> image with the <b>ping localhost</b> command</p>
      """
command_expected: ["ice", "run", "--name", "ice-ping",  "learn/ping", "ping", "localhost"]
command_show: ["ice", "run", "--name", "ice-ping",  "learn/ping", "ping", "localhost"]
result: """<p>Success! The image is up and running on Bluemix!</p>"""
intermediateresults:
  [
    () -> """getting there, try pinging 'localhost' instead."""
    () -> """Try naming the container 'ice-ping'"""
  ]
tip: """
    <ul>
    <li>Notice that we will not use the <code>--local</code> because we are running on Bluemix, not local.</li> 
    <li>Enter <code>ice run</code> to see flag usage details</li>
    </ul>
    """
currentIcePs: """

  Container Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports

  fa219a32-bcbf-4c6d-977f-1aa67bb1233d ice-ping                          learn/ping:latest              Apr 22 10:42 Shutdown 172.12.228.45                   []
  """
});

q.push ({
html: """
      <h3>Check the running app</h3>
      <p>When you run the app on Bluemix you get the ID for your container. We want to see what's going on inside.</p>
      <p>To do this we will use <code>ice logs</code>. this will let us see the output produced by our pings to localhost.</p>
      <p>Before checking logs lets check the status of the container using <code>ice ps</code>. ps will give you information about your containers and their state. This way we can make sure the ice-ping is up and running.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>After checking the state using <code>ice ps</code> go ahead and get logs using <code>ice logs</code>.</p>
      """
command_expected: ["ice", "logs", "ice-ping"]
command_show: ["ice", "logs", "ice-ping"]
result: """<p>Success! You now know how to check logs, and container status.</p>"""
intermediateresults:
  [
    #missing name
    #missing image
    #missing command
    () -> """"""
  ]
tip: """
    <ul>
    <li>Don't forget to specify the Container name in your call to <code>ice logs</code>. </li>
    <li>You can also use <code>ice inspect</code> to get more information about your running app. Give it a try.</li>
    </ul>
    """
});

q.push ({
html: """
      <h3>working with IP's</h3>
      <p>We now have a container up and running, but right now the container does not have a public IP. It is not accessible from outside of the bluemix.</p>
      <p>If we were running a web server in the container we need to bind a public IP to the container. For our ping image it is not necessary to bind an IP but for the sake of learning, let's do it anyways!</p>
      <p>There are two steps in this process, first we will need to request an ip from Bluemix using <code>ice ip request</code>
      This will give us the IP that will be bound to our container. Once we have the IP we must then bind it to the container using <code>ice ip bind</code>
      </p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>request an ip from Bluemix and bind it to our container using <code>ice ip bind</code></p>
      """
command_expected: ["ice", "ip", "bind", "129.41.232.25", "ice-ping"]
command_show: ["ice", "ip", "bind", "129.41.232.25", "ice-ping"]
result: """<p>Success! We now have an IP bound to our container!</p>"""
intermediateresults:
  [
    () -> """Looks like you have the right IP but no container name."""
    () -> """Looks like you are missing an IP and Container name."""
    () -> """That doesnt look like the IP that Bluemix gave you. remember to use the IP provided by 'ice ip request.'"""
    () -> """Whoops, looks like you misspelled the container name try ice-ping"""
  ]
tip: """
    <ul>
    <li>For usage type <code>ice ip --help</code> or <code>ice ip bind --help</code></li>
    <li>You can release a requested IP using <code>ice ip release</code> note: ip release is not supported by this emulator.
    </ul>
    """
});


q.push ({
html: """
      <h3>Cleaning up</h3>
      <p>We've gone through all the main steps required for deploying docker containers to Bluemix. Now we'll finish up by learning how to stop and remove our container.</p>
      <p>Before we do anything we are going to need to stop our running app using <code>ice stop</code></p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Use <code>ice stop</code> to stop the container. Then use <code>ice rm</code> to remove the <b>ice-ping</b> container</p>
      """
command_expected: ["ice", "rm", "ice-ping"]
command_show: ["ice", "rm", "ice-ping"]
result: """<p>Great job! ice-ping has been stopped and removed. You Have completed the ice CLI tutorial! Hit next to move on to the <em style="color:aquamarine;">Advanced</em> tutorial!</p>"""
tip: """
    <ul>
    <li>type <code>ice stop --help</code> and <code>ice rm --help</code> for complete usage.</li>
    </ul>
    """
intermediateresults:
  [
    () ->
      $('#instructions .assignment').hide()
      $('#tips, #command').hide()
    
      $('#instructions .text').html("""
        <div class="complete">
          <h3>Congratulations!</h3>
          <p>You have mastered the basic docker commands!</p>
          <p><strong>Did you enjoy this tutorial? Share it!</strong></p>
          <p>
            <a href="mailto:?Subject=Check%20out%20the%20Docker%20interactive%20tutorial!&Body=%20JSTART"><img src="/static/img/email.png"></a>
            <a href="http://www.facebook.com/sharer.php?u=JSTART"><img src="/static/img/facebook.png"></a>
            <a href="http://twitter.com/share?url=JSTART&text=%20Check+out+the+docker+tutorial!"><img src="/static/img/twitter.png"></a>
          </p>
          <h3>Your next steps</h3>
          <ol>
            <li><a href="/news_signup/" target="_blank" >Register</a> for news and updates on Docker (opens in new window)</li>
            <li><a href="http://twitter.com/docker" target="_blank" >Follow</a> us on twitter (opens in new window)</li>
            <li><a href="#" onClick="leaveFullSizeMode()">Close</a> this tutorial, and continue with the rest of the getting started.</li>
          </ol>
          <p> - Or - </p>
          <p>Continue to learn the advanced features of the ice CLI. </p><p><a onclick="switchToAdvanced()" class='btn btn-primary secondary-action-button'>Start <em style="color:crimson;">Advanced</em> tutorial</a></p>

        </div>
        """)


      data = { type: EVENT_TYPES.complete }
      logEvent(data)

  ]
finishedCallback: () ->
  webterm.clear()
  webterm.echo( myTerminal() )

      

})

###
  Array of ADVANCED question objects
###

adv_q = []
adv_q.push ({
html: """
      <h3>Volumes</h3>
      <p>A data volume is a specially-designated directory within one or more containers that bypasses the Union File System. Data volumes provide several useful features for persistent or shared data:</p>
      <ul>
        <li>Volumes are initialized when a container is created. If the container's base image contains data at the specified mount point, that data is copied into the new volume.</li>
        <li>Data volumes can be shared and reused among containers.</li>
        <li>Changes to a data volume are made directly.</li>
        <li>Changes to a data volume will not be included when you update an image.</li>
        <li>Data volumes persist even if the container itself is deleted.</li>
      </ul>
      <p>Data volumes are designed to persist data, independent of the container's life cycle. Docker therefore never automatically delete volumes when you remove a container, 
      nor will it "garbage collect" volumes that are no longer referenced by a container.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>In this exercise we will create a Volume on our Bluemix org so that it can be bound to containers.</p>
      <p>Go ahead and use the <code>ice volume</code> commands to create a volume named <b>storage</b></p>
      """
command_expected: ['ice', 'volume', 'create', 'storage']
tip: """
    <ul>
      <li>Use <code>ice volume list</code> to list images</li>
      <li>Use <code>ice volume -h</code> to see all the available commands</li>
    </ul>
     """
result: """<p>Sweeet! now we're ready to bind a volume to a running container!</p>"""
currentIcePs: """

  Container Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports

  """
})

adv_q.push ({
html: """
      <h3>Attaching Volumes</h3>
      <p>Volumes are attached to containers in the run command by using the <code>--volume VolumeId:ContainerPath[:ro]</code> flag/</p>
      <p>The Volume Id is the volume's name (in our example 'storage'), the container path is the directory inside the container that the 
      attached volume will mount. This means that all the data written to the specified container path will be stored on the Volume. If the </p>
      <p>There is an optional arguement for granting permissions [:ro] (read only). If not specified the Volume will default to :rw (read write).</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Use the <code>ice run</code> command to run a container named <b>iceVolume</b>, running the ibmnode image. Attach the <b>storage</b> volume to the /var/images directory.</p>
    """
command_expected: ['ice', 'run', '--name', 'iceVolume', '--volume', 'storage:/var/images', 'ibmnode']
result: """<p>You did it! Way to go!</p>"""
tip: """
    <ul>
      <li>use <code>ice run -h</code> to see the detailed flag details.</li>
      <li>Note: the ice cli allows you to use -v and -n as equivalents to --volume and --name however this tutorial enforces the use of the long flag names.</li>
    </ul>
    """
    
currentIcePs: """

  Container Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports

  dc3ced78-61ed-4870-b668-411c87d2419d iceVolume                         ibmnode:latest                 Apr 30 10:18 Running                                    []
  """
})

adv_q.push ({
html: """
      <h3>Binding Apps to Bluemix</h3>
      <p>You may already have applications running on Bluemix. Maybe these apps have services bound to them. These services could include things 
      like Databases, or APIs. With ice you can take bind existing applications to you container. This gives the bound container access to all 
      the services which are already bound to the app.</p>
      <p>After a bind, all the services will store their connection info and credentials in the <code>VCAP_SERVICES</code> environment variable</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>For this emulator we have provisioned an application called <b>myDB</b> it is a simple app connected to a MySQL Database, we want this database
      to be accessible from the container.</p>
      <p>start up another container named <b>boundDB</b> on the ibmnode image. Make sure to bind <b>myDB</b></p>
      """
command_expected: ['ice', 'run', '--name', 'boundDB', '--bind', 'myDB', 'ibmnode']
result: """<p>Whoop! nice job, All the services are now available to you container.</p>"""
tip: """"
    use the <code>--bind</code> flag to bind the app.
    note: the ice command line supports the use of either --bind or -b for binding, but this tutorial enforces the use of the long flag names.
    """
currentIcePs: """

  Container Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports

  0261b157-9390-4e5d-88ad-a73de12aacb0 boundDB                           ibmnode:latest                 Apr 30 14:40 Running  172.12.128.55                   []
  dc3ced78-61ed-4870-b668-411c87d2419d iceVolume                         ibmnode:latest                 Apr 30 10:18 Running  172.12.128.55                   []
  """
})

adv_q.push ({
html: """
      <h3>Creating Container Groups</h3>
      <p>Bluemix allows you create container groups to load balance your application. You can have a group comprised of 1 or more containers.
      Each container is an exact copy so incoming connections are balanced between containers. This redundancy also gives applications more stability.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>use <code>ice create</code> to create a group named</p>
      """
command_expected: ['ice', 'group', 'create', '-p', '80', '--name', 'myGroup', 'ibmnode']
result: """<p>You found it! Way to go!</p>"""
tip: """
  <ul>
    <li>You can use the <code>--auto</code> flag to have Bluemix automatically restart failed instances.</li>
    <li>You can use the <code>--desired</code> flag to specify the number of instances that you require. The default is 2.</li>
    <li>Deleting groups is done using <code>ice group rm</code> (not a part of this emulator)</li>
    <li>it is possible to pass commands to the ice group create command, the command will run on all containers on the group.</li>
  </ul>
"""
currentIceGroups: """

Group Id                             Name             Status               Created             Updated             Port

8f97d754-e8fc-4128-ba75-f0d8f3a868ce myGroup          CREATE_COMPLETE      2015-04-28T18:57:42                     80
"""
currentIcePs: """

  Container Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports

  21c6724d-50e2-43fc-b947-fd76ef26fc2d my-ogvl-7g734rpjvvy... myGroup    ibmnode:latest                 Apr 30 15:28 Running  172.12.128.58                   []
  cfb39cf2-1a38-4ca3-b948-4e5ae2b56dd2 my-ogvl-m5yb5noyrsj... myGroup    ibmnode:latest                 Apr 30 15:28 Running  172.12.128.57                   []
  0261b157-9390-4e5d-88ad-a73de12aacb0 boundDB                           ibmnode:latest                 Apr 30 14:40 Running  172.12.128.55                   []
  c684ae10-b410-4ad7-b866-babcb380ec8f wp3                               jstart/wordpress:latest        Apr 28 15:03 Running  172.12.128.46   129.41.232.65   [80]
  """
})

adv_q.push ({
html: """
      <h3>Working With Routes</h3>
      <p>Before we get too far go ahead, check you running containers with <code>ice ps</code>. you can also check your groups using <code>ice group list</code></p>
      <p>So now we have this group of containers, We could use ice to bind an ip to the group. But we already did that and it would be much more convenient 
      to have a route instead of an ip address. Bluemix allows us to bind routes to groups by using the <code>ice route map</code> command</p>
      """
assignment:
      """
      <h3>Assignment</h3>
      <p>We need to bind a route to <b>myGroup</b>. the hostname will be <b>groupRoute</b> and the domain will be <b>mybluemix.net</b></p>
      """
command_expected: ['ice', 'route', 'map', '--hostname', 'groupRoute', '--domain' , 'mybluemix.net','myGroup']
result: """<p>Cool. Look at the results. You'll see that ice has bound a Route to your container!.</p>"""
tip: """
    <ul>
    <li>use <code>ice route map -h</code> for usage details.</li>
    <li>you can unmap routes using <code>ice route unmap</code> (not a part of this tutorial)</li>
    <li>Your group must have an exposed port inorder for routing to work!</li>
    <li>you will need to use <code>--hostname</code> and <code>--domain</code> to specify the hostname and domain!</li>
    </ul>
     """
intermediateresults:
  [
    () ->
      $('#instructions .assignment').hide()
      $('#tips, #command').hide()

      $('#instructions .text').html("""
        <div class="complete">
          <h3>Congratulations!</h3>
          <p>You have mastered the <em style="color:aquamarine;">Advanced</em> docker commands!</p>
          <p><strong>Did you enjoy this tutorial? Share it!</strong></p>
          <p>
            <a href="mailto:?Subject=Check%20out%20the%20Docker%20interactive%20tutorial!&Body=%20JSTART"><img src="/static/img/email.png"></a>
            <a href="http://www.facebook.com/sharer.php?u=JSTART"><img src="/static/img/facebook.png"></a>
            <a href="http://twitter.com/share?url=JSTART&text=%20Check+out+the+docker+tutorial!"><img src="/static/img/twitter.png"></a>
          </p>
          <h3>Your next steps</h3>
          <ol>
            <li><a href="/news_signup/" target="_blank" >Register</a> for news and updates on Docker (opens in new window)</li>
            <li><a href="http://twitter.com/docker" target="_blank" >Follow</a> us on twitter (opens in new window)</li>
            <li><a href="#" onClick="leaveFullSizeMode()">Close</a> this tutorial, and continue with the rest of the getting started.</li>
          </ol>
          <p> - Or - </p>
          <p>Continue to learn about the way to automatically build your containers from a file. </p><p><a href="/learn/dockerfile/" class='btn btn-primary secondary-action-button'>Start Dockerfile tutorial</a></p>

        </div>
        """)


      data = { type: EVENT_TYPES.complete }
      logEvent(data)

      #return """<p>All done!. You are now pushing a container image to the index. You can see that push, just like pull, happens layer by layer.</p>"""
  ]
finishedCallback: () ->
  webterm.clear()
  webterm.echo( myTerminal() )

})


# the index arr
questions = []


###
  Register the terminal
###

@webterm = $('#terminal').terminal(interpreter, basesettings)

EVENT_TYPES =
  none: "none"
  start: "start"
  command: "command"
  next: "next"
  peek: "peek"
  feedback: "feedback"
  complete: "complete"



###
  Sending events to the server (disabled for ice tutorial)
###
logEvent = (data, feedback) ->
    console.log(data)


###
  Event handlers
###

## next
$('#buttonNext').click (e) ->

  # disable the button to prevent spacebar to hit it when typing in the terminal
  this.setAttribute('disabled','disabled')
  console.log(e)
  next()

$('#buttonFinish').click ->
  window.open(COMPLETE_URL)

## previous
$('#buttonPrevious').click ->
  previous()
  $('#results').hide()

## Stop mousewheel on left side, and manually move it.
$('#leftside').bind('mousewheel',
  (event, delta, deltaX, deltaY) ->
    this.scrollTop += deltaY * -30
    event.preventDefault()
  )

## submit feedback
$('#feedbackSubmit').click ->
  feedback = $('#feedbackInput').val()
  data = { type: EVENT_TYPES.feedback, feedback: feedback}
  logEvent(data, feedback=true)

## fullsize
$('#fullSizeOpen').click ->
  goFullScreen()

@goFullScreen = (start) ->
  

  window.scrollTo(0, 0)
  console.debug("going to fullsize mode")
  $('.togglesize').removeClass('startsize').addClass('fullsize')

  $('.hide-when-small').css({ display: 'inherit' })
  $('.hide-when-full').css({ display: 'none' })

  if start is 'adv'
    switchToAdvanced()
  else
    switchToBasic()

  next(0)

  webterm.resize()

  # send the next event after a short timeout, so it doesn't come at the same time as the next() event
  # in the beginning. Othewise two sessions will appear to have been started.
  # This will make the order to appear wrong, but that's not much of an issue.

  setTimeout( () ->
    logEvent( { type: EVENT_TYPES.start } )
  , 3000)


## leave fullsize
$('#fullSizeClose').click ->
  leaveFullSizeMode()

@leaveFullSizeMode = () ->
  console.debug "leaving full-size mode"

  $('.togglesize').removeClass('fullsize').addClass('startsize')

  $('.hide-when-small').css({ display: 'none' })
  $('.hide-when-full').css({ display: 'inherit' })

  webterm.resize()

## click on tips
$('#command').click () ->
  if not $('#commandHiddenText').hasClass('hidden')
    $('#commandHiddenText').addClass("hidden").hide()
    $('#commandShownText').hide().removeClass("hidden").fadeIn()

  data = { type: EVENT_TYPES.peek }
  logEvent(data)



###
  Navigation amongst the questions
###


current_question = 0
next = (which) ->
  # before increment clear style from previous question progress indicator
  $('#marker-' + current_question).addClass("complete").removeClass("active")
  if which is 'ADV'
    switchToAdvanced()
  else if which is '←'
  else if not which and which != 0
    current_question++
    if current_question is questions.length
      next('ADV')
  else
    current_question = which

  questions[current_question]()
  results.clear()
  @webterm.focus()

  if not $('#commandShownText').hasClass('hidden')
    $('#commandShownText').addClass("hidden")
    $('#commandHiddenText').removeClass("hidden").show()

  # enable history navigation
  history.pushState({}, "", "#" + current_question);
  data = { 'type': EVENT_TYPES.next }
  logEvent(data)

  # change the progress indicator
  $('#marker-' + current_question).removeClass("complete").addClass("active")



  $('#question-number').find('text').get(0).textContent = current_question

  # show in the case they were hidden by the complete step.
  $('#instructions .assignment').show()
  $('#tips, #command').show()


  return

previous = () ->
  current_question--
  questions[current_question]()
  results.clear()
  @webterm.focus()
  return



results = {
  set: (htmlText, intermediate) ->
    if intermediate
      console.debug "intermediate text received"
      $('#results').addClass('intermediate')
      $('#buttonNext').hide()
    else
      $('#buttonNext').show()

    window.setTimeout ( () ->
      $('#resulttext').html(htmlText)
      $('#results').fadeIn()
      $('#buttonNext').removeAttr('disabled')
    ), 300

  clear: ->
    $('#resulttext').html("")
    $('#results').fadeOut('slow')
}



###
  Transform question objects into functions
###

buildfunction = (question) ->
  _q = question
  return ->
    console.debug("function called")

    $('#instructions').hide().fadeIn()
    $('#instructions .text').html(_q.html)
    $('#instructions .assignment').html(_q.assignment)
    $('#tipShownText').html(_q.tip)
    if _q.command_show
      $('#commandShownText').html(_q.command_show.join(' '))
    else
      $('#commandShownText').html(_q.command_expected.join(' '))

    if _q.currentDockerPs?
      window.currentDockerPs = _q.currentDockerPs
    else
      window.currentDockerPs = staticDockerPs

    # as the user progresses images are added to the registries
    if _q.currentLocalImages?
      window.currentLocalImages = _q.currentLocalImages

    if _q.currentCloudImages?
      window.currentCloudImages = _q.currentCloudImages

    if _q.currentCloudImages?
      window.currentCloudImages = _q.currentCloudImages

    if _q.currentIceGroups?
      window.currentIceGroups = _q.currentIceGroups

    if _q.currentIcePs?
      window.currentIcePs = _q.currentIcePs
    else
      window.finishedCallback = () -> return ""

    window.immediateCallback = (input, stop) ->
      if stop == true # prevent the next event from happening
        doNotExecute = true
      else
        doNotExecute = false

      if doNotExecute != true
        console.log (input)

        data = { 'type': EVENT_TYPES.command, 'command': input.join(' '), 'result': 'fail' }

        # Was like this:  if not input.switches.containsAllOfThese(_q.arguments)
        if input.containsAllOfTheseParts(_q.command_expected)
          data.result = 'success'

          setTimeout( ( ->
            @webterm.disable()
            $('#buttonNext').focus()
          ), 1000)

          results.set(_q.result)
          console.debug "contains match"
        else
          console.debug("wrong command received")

        # call function to submit data
        logEvent(data)
      return

    window.intermediateResults = (input) ->
      if _q.intermediateresults
        results.set(_q.intermediateresults[input](), intermediate=true)
    return


statusMarker = $('#progress-marker-0')
progressIndicator = $('#progress-indicator')
leftside = $('#leftside')
tutorialTop = $('#tutorialTop')
advancedTag = $('#advancedTag')

window.switchToBasic = switchToBasic = () -> 
  questions = []
  statusMarker.nextAll('span').remove()
  leftside.animate({ backgroundColor: "#26343f" }, 1000 )
  tutorialTop.animate({ backgroundColor: "#26343f" }, 1000 )
  advancedTag.fadeOut()
  questionNumber = 0
  for question in q
    f = buildfunction(question)
    questions.push(f)
    drawStatusMarker(questionNumber)
    if questionNumber > 0
      $('#marker-' + questionNumber).removeClass("active").removeClass("complete")
    else
      $('#marker-' + questionNumber).removeClass("complete").addClass("active")
    questionNumber++
  drawStatusMarker('ADV')

  # go to first question  
  next(0)

window.switchToAdvanced = switchToAdvanced = () -> 
  questions = []
  statusMarker.nextAll('span').remove()
  leftside.animate({ backgroundColor: "#543B3B" }, 1000 )
  tutorialTop.animate({ backgroundColor: "#3F2626" }, 1000 )
  advancedTag.fadeIn()

  marker = statusMarker.clone()
  marker.prependTo(progressIndicator)
  marker.title = 'Go back to the Basic Tutorial'

  marker.attr("id", "marker-" + 'BSC')
  marker.find('text').get(0).textContent = '←'
  marker.click( -> next(0) )

  questionNumber = 0
  for question in adv_q
    f = buildfunction(question)
    questions.push(f)
    drawStatusMarker(questionNumber)
    if questionNumber > 0
      $('#marker-' + questionNumber).removeClass("active").removeClass("complete")
    else
      $('#marker-' + questionNumber).removeClass("complete").addClass("active")
    questionNumber++

  # go to first question  
  next(0)


drawStatusMarker = (i) ->
  if i == 0
    marker = statusMarker
  else
    marker = statusMarker.clone()
    marker.appendTo(progressIndicator)

  marker.attr("id", "marker-" + i)
  marker.find('text').get(0).textContent = i
  marker.click( -> next(i) )



questionNumber = 0
for question in q
  f = buildfunction(question)
  questions.push(f)
  drawStatusMarker(questionNumber)
  questionNumber++
drawStatusMarker('ADV')

###
  Initialization of program
###

#load the first question, or if the url hash is set, use that
if (window.location.hash)
  try
    currentquestion = window.location.hash.split('#')[1].toNumber()
#    questions[currentquestion]()
#    current_question = currentquestion
    next(currentquestion)

  catch err
    questions[0]()
else
  questions[0]()

$('#results').hide()

