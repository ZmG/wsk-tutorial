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
      """
assignment: """
      <h3>Assignment</h3>
      <p>Check IBM Containers Extension (ICE) to identify the version of the client that you are running</p>
      <p>This will help you verify which version of the ICE CLI is running. If you see a version value
      then you know you that your all set with your ICE client installation. The ICE CLI is supported on Linux OS.
      For Windows, your best option is to create an Ubuntu VM and install your client software there.</p>
      """
tip: "<p>Try typing <code>ice</code> to see the full list of accepted arguments</p>
      <p>This emulator provides only a limited set of shell and ICE commands, so some commands may not work as expected</p>"
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
      <p>Use the <code>ice login</code> command to log in to the IBM Containers infrastructure while manually specifying your cloud service host or url using the <b>short option format</b>. Ice will ask you for a username and password, any value will work.</p>
      """
command_expected: ['ice', 'login', '-H', 'https://api-ice.ng.bluemix.net/v2/containers']
result: """<p>You found it! Way to go!</p>"""
intermediateresults: [
  () -> """<p>You seem to be almost there. Did you specify the host with </b>'-h  https://api-ice.ng.bluemix.net/v2/containers'</b> """,
  () -> """<p>You've got the arguments right. Did you get the command? Try <em>/bin/bash </em>?</p>"""
  ]
tip: "the optional arguments for login are specified in the online Bluemix Containers doc"
})

q.push ({
html: """
      <h3>Downloading container images</h3>
      <p>This exercise will introduce the --local. calling ice --local is the same as calling docker. ice --local will pass arguements to docker and run like standard docker.</p>
      <p>Container images can be downloaded just as easily, using <code>docker pull</code>.</p>
      <p>However, instead of calling <code>docker pull</code> directly we will use <code>ice --local pull</code>, to pull images from registry-ice.ng.bluemix.net/&lt;Namespace&gt;/&lt;Image&gt;.</p>
      <p>For images from the central index, the name you specify is constructed as &lt;Namespace&gt;/&lt;Image Name&gt;</p>
      <p>A group of special, trusted images such as the ubuntu base image can be retrieved by just their name &lt;Image Name&gt;.</p>
      """
assignment:
      """
      <h3>Assignment</h3>
      <p>Pull the <b>'tutorial'</b> image from the <b>'learn'</b> namespace in the <b>'registry-ice.ng.bluemix.net'</b> registry</p>
      """
command_expected: ['ice', '--local', 'pull', 'registry-ice.ng.bluemix.net/learn/tutorial']
result: """<p>Cool. Look at the results. You'll see that ice has invoked docker to download a number of layers. In Docker all images (except the base image) are made up of several cumulative layers.</p>"""
intermediateresults: [
  () -> """<p>You seem to be almost there. Don't forget to tell <b>ice --local pull</b> where to find the image, ice --local pull &lt;<Registry url>&gt;/&lt;learn&gt;/&lt;tutorial&gt; """,
  () -> """<p>You got the namespace and image name correct, but forgot to specify a registry, hint ice --local pull &lt;Registry url&gt;/&lt;Namespace&gt;/&lt;Image Name&gt;</p>"""
  ]
tip: """
    <ul>
      <li>Don't forget to pull the full name of the repository e.g. 'learn/tutorial'</li>
      <li>For this tutorial the Namespace for you registry will always be <b>'learn'</b></li>
      <li>Look under 'show expected command if you're stuck.</li>
    </ul>
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
command_expected: ["ice", "--local", "run", "learn/tutorial", "echo", "hello"]
command_show: ["docker", "run", "learn/tutorial", 'echo "hello world"']

result: """<p>Great! Hellooooo World!</p><p>You have just started a container and executed a program inside of it, when
        the program stopped, so did the container."""
intermediateresults: [
  () -> """<p>You seem to be almost there. Did you give the command `echo "hello world"` """,
  () -> """<p>You've got the arguments right. Did you get the command? Try <em>/bin/bash </em>?</p>"""
  ]
tip: """
     <p>The command <code>docker run</code> takes a minimum of two arguments. An image name, and the command you want to execute
     within that image.</p>
     <p>Check the expected command below if it does not work as expected</p>
    """
})

q.push ({
html: """
      <h3>Installing things in the container</h3>
      <p>Next we are going to install a simple program (ping) in the container. The image is based upon ubuntu, so you
      can run the command <code>apt-get install -y ping</code> in the container. </p>
      <p>Note that even though the container stops right after a command completes, the changes are not forgotten.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Install 'ping' on top of the learn/tutorial image.</p>
      """
command_expected: ["ice", "--local", "run", "learn/tutorial", "apt-get", "install", "-y", "ping"]
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
      <h3>Run your new image</h3>
      <p>Now you have basically setup a complete, self contained environment with the 'ping' program installed. </p>
      <p>Your image can now be run on any host that runs Docker.</p>
      <p>Lets run this image on this machine.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Run the ping program to ping www.google.com</p>

      """
command_expected: ["ice", "--local", "run", 'learn/ping', 'ping', 'google.com' ]
result: """<p>That worked! Note that normally you can use Ctrl-C to disconnect. The container will keep running. This
        container will disconnect automatically.</p>"""
intermediateresults: [ () -> """You have not specified a repository name. This is not wrong, but giving your images a name
                      make them much easier to work with."""]
tip: """<ul>
     <li>Make sure to use the repository name learn/ping to run ping with</li>
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
     <li>Remember you can use a partial match of the image id</li>
     </ul>"""
currentDockerPs:
    """
    ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS
    efefdc74a1d5        learn/ping:latest   ping www.google.com   37 seconds ago      Up 36 seconds
    """

})



q.push ({
html: """
      <h3>Tagging your image with ice</h3>
      <p>Now you have verified that your application container works locally, it's time to get it ready for Bluemix.</p>
      <p>Remember you pulled (downloaded) the learn/tutorial image from the Bluemix Private Registry? You can also share your built images
      to the Registry by pushing (uploading) them to there. That way you can easily retrieve them for re-use and share them
      with others. </p>

      <p>To use an image on bluemix, you will first need to push the image up to your,
      bluemix registry. To do that we need to tag the pulled image with your namespace and a name, that will identify it in your 
      bluemix registry.
      </p>

      <p>Note: You can also push images downloaded from the <a href="registry.hub.docker.com">Docker Public Registry</a> to your Bluemix Private Registry.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Tag the learn/tutorial image using <code>ice --local tag</code>. tag the image with the name <b>'learn/ping'</b>. This prepares the image for pushing to the bluemix registry.</p>

      """
command_expected: ["ice", "--local", "tag", "learn/tutorial", "registry-ice.ng.bluemix.net/learn/ping"]
command_show: ["ice", "--local", "tag", "learn/tutorial", "registry-ice.ng.bluemix.net/learn/ping"]
result: """<p>Success! The image is now tagged and ready to push. In the next section we'll push to the registry</p>"""
intermediateresults:
  [
    () -> """Almost there, don't forget provide the name of the local image that will be tagged (learn/tutorial) usage: 'ice --local tag <b>&lt;local_Image&gt;</b> registry-ice.ng.bluemix.net/&lt;Namespace&gt;/&lt;Image_name&gt;'"""
  ]
tip: """
    <ul>
    <li><code>ice images</code> will show you which images are currently on your host</li>
    <li><code>ice --local images</code> will show you which images exist locally (docker)</li>
    <li>For more usage info see the docs <a a href="https://www.ng.bluemix.net/docs/#starters/index-gentopic3.html#container_install">here</a></li>
    <li>You can only push images to your own namespace, this emulator uses the namespace 'learn'</li>
    </ul>
    """
});

###intermediateresults:
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
            <a href="mailto:?Subject=Check%20out%20the%20Docker%20interactive%20tutorial!&Body=%20https://www.docker.io/gettingstarted/"><img src="/static/img/email.png"></a>
            <a href="http://www.facebook.com/sharer.php?u=https://www.docker.io/gettingstarted/"><img src="/static/img/facebook.png"></a>
            <a href="http://twitter.com/share?url=https://www.docker.io/gettingstarted/&text=%20Check+out+the+docker+tutorial!"><img src="/static/img/twitter.png"></a>
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

      return """<p>All done!. You are now pushing a container image to the index. You can see that push, just like pull, happens layer by layer.</p>"""
  ]
  finishedCallback: () ->
  webterm.clear()
  webterm.echo( myTerminal() )


})
###


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

@goFullScreen = () ->
  console.debug("going to fullsize mode")
  $('.togglesize').removeClass('startsize').addClass('fullsize')

  $('.hide-when-small').css({ display: 'inherit' })
  $('.hide-when-full').css({ display: 'none' })

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

  if not which and which != 0
    current_question++
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

buildfunction = (q) ->
  _q = q
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

    if _q.finishedCallback?
      window.finishedCallback = q.finishedCallback
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
progressIndicator = $('#progress-indicator')#

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

