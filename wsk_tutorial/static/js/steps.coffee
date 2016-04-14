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
      <h3>OpenWhisk Getting started</h3>
      <p>OpenWhisk is an event-driven compute platform that executes code in response to events or direct invocations.
      </p>
      <p>Examples of events include changes to database records, IoT sensor readings that exceed a certain temperature, new code commits to a GitHub repository, or simple HTTP requests from web or mobile apps. Events from external and internal event sources are channeled through a trigger, and rules allow actions to react to these events. </p>
      <p>Actions can be small snippets of Javascript or Swift code, or custom binaries embedded in a Docker container. Actions in OpenWhisk are instantly deployed and executed whenever a trigger fires. The more triggers fire, the more actions get invoked. If no trigger fires, no action code is running, so there is no cost.</p>
      <p>In addition to associating actions with triggers, it is possible to directly invoke an action by using the OpenWhisk API, CLI, or iOS SDK. A set of actions can also be chained without having to write any code. Each action in the chain is invoked in sequence with the output of one action passed as input to the next in the sequence.</p> <a href="https://new-console.ng.bluemix.net/docs/openwhisk/index.html"> Getting Started with Bluemix OpenWhisk documentation</a>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Use a wsk command to see the full list of accepted arguments</p>
      <p>If you see a list of arguments then you know that you are all set with your wsk client installation.</p>
      """
intermediateresults: [
  () -> """<p>Whisk argument swithces usually start with two dashes. Try "--help"</p>"""
  ]
tip: "<p>This emulator provides only a limited set of shell and wsk commands, so some commands may not work as expected</p>"
command_expected: ['wsk', '--help']
result: """<p>Well done! Let's move to the next assignment.</p>"""
})

q.push ({
html: """
      <h3>Creating a JavaScript Action</h3>
      <p>Actions encapsulate an actual code to be executed. One can think of an action as a piece of code that runs in response to an event. Actions support multiple language bindings including NodeJS, Swift and arbitrary binary programs encapsulated in Docker Containers. Actions invoke any part of an open ecosystem including existing Bluemix services for analytics, data, cognitive, or any other 3rd party service. </p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Create an action called "hello" from the content of the "hello.js" file. Use the verbose switch to examine API calls.</p>
      """
command_expected: ['wsk','-v', 'action', 'create', 'hello', 'hello.js']
result: """<p>You found it! Way to go!</p>"""
tip: "For this assignment, the file 'hello.js' had been already created. Perform a 'ls' to ensure file exists and 'cat hello.js' to examine the contents of the file"
})

q.push ({
html: """
      <h3>List actions that have been created. </h3>
      <p>Existing and newly created actions can be looked up by using a wsk command.</p>
      """
assignment:
      """
      <h3>Assignment</h3>
      <p>List the actions you have created</p>
      """
command_expected: ['wsk', 'action', 'list']
result: """<p>Cool. Look at the result. You'll see that the action created in step 1 was listed</p>"""
})

q.push ({
html: """
      <h3>Running an action using a blocking invocation</h3>
      <p>After you create your action, you can run it in the cloud in OpenWhisk with the 'invoke' command. You can invoke actions with a blocking
      invocation or a non-blocking invocation by specifying a flag in the command. A blocking invocation waits until the action runs to completion and
      returns a result. This example uses blocking invocation.</p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Invoke the hello action utilizing blocking invocation.  </p>
      """
command_expected: ['wsk', 'action', 'invoke', '--blocking', 'hello']
command_show: ['wsk', 'action', 'invoke', '--blocking', 'hello']

result: """<p>Great! The command outputs two important pieces of information:
            <li>
              <ul>The activation ID (44794bd6aab74415b4e42a308d880e5b)</ul>
              <ul>The invocation result. The result in this case is the string Hello world 
              returned by the JavaScript function. The activation ID can be used to 
              retrieve the logs or result of the invocation at a future time.</ul>
            </li>"""
intermediateresults: [
  () -> """<p>You seem to be almost there. Did you feed in the "wsk action" command "invoke --blocking hello" parameters?"""
  ]
tip:"""
    <ul>
       <li>Remember to use wsk action command.</li>
    </ul>
    """
})

q.push ({
html: """
      <h3>Running an action using a non-blocking invocation</h3>
      <p>If you don't need the action result right away, you can omit the --blocking flag to make a non-blocking invocation. You can get the result later by using the activation ID. </p>
      """
assignment: """
            <h3>Assignment</h3>
            <p>Invoke the "hello" action utilizing non-blocking invocation.  </p>
            """
command_expected: ['wsk', 'action', 'invoke', 'hello']
command_show: ['wsk', 'action', 'invoke', 'hello']

result: """<p>Great! Action was invoked. Next we are going to obtain the result"""
intermediateresults: [
  () -> """<p>You seem to be almost there. Did you feed in the wsk action command "invoke hello" parameters"""
  ]
tip:  """
      <ul>
        <li>Remember to use wsk action</li>
      </ul>
      """
})

q.push ({
html: """
      <h3>Get action's invocation result using the activation ID</h3>
      <p>You can get an actions result by using the action activation ID. If you forgot to record the activation ID, you can get a list of activations ordered from most recent to the oldest running the <code> wsk activation list</code> command </p>
      """
assignment: """
      <h3>Assignment</h3>
      <p>Obtain a non-blocking action's result.  Remember, a non-blocking invocation may execute in the background so obtaining the result requires the activation ID</p>
      """
command_expected: ["wsk", "activation", "result", "6bf1f670ee614a7eb5af3c9fde813043"]
command_show: ["wsk", "activation", "result", "6bf1f670ee614a7eb5af3c9fde813043"]

result: """<p>Great! End of tutorial"""
intermediateresults: [
  () -> """<p>You seem to be almost there. Did you feed in the wsk action command "list" parameter and the activation ID"""
  ]
tip: """
  <ul>
     <li>You need to use the activation result command and supply the activation ID</li>
  </ul>
  """
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


isNumber = (n) ->
  return !isNaN(parseFloat(n)) && isFinite(n);

@goFullScreen = (start) ->


  window.scrollTo(0, 0)
  console.debug("going to fullsize mode")
  $('.togglesize').removeClass('startsize').addClass('fullsize')

  $('.hide-when-small').css({ display: 'inherit' })
  $('.hide-when-full').css({ display: 'none' })

  if start is 'adv'
    switchToAdvanced()
  else if start is 'basic'
    switchToBasic()
  else if isNumber(start)
    next(start)
  else if endsWith(start, 'ADV')
    switchToAdvanced()
    index = start.split('-')[0]
    next(index)
  else
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
endsWith = (str, suffix) ->
  return str.indexOf(suffix, str.length - suffix.length) isnt -1



current_question = 0
window.next = next = (which) ->
  # before increment clear style from previous question progress indicator
  $('#marker-' + current_question).addClass("complete").removeClass("active")
  if which is 'ADV'
    switchToAdvanced()
  else if which is '←'
    switchToBasic()
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
  if window.advancedTut is true
    history.pushState({}, "", "#" + current_question + "-ADV")
    window.location.hash = "#" + current_question + "-ADV"
  else
    history.pushState({}, "", "#" + current_question)
    window.location.hash = "#" + current_question
  # disabled to enable tutorial hashes to redirect to correct questions

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
  window.advancedTut = false
  questions = []
  statusMarker.prevAll('span').remove()
  statusMarker.nextAll('span').remove()
  leftside.animate({ backgroundColor: "#26343f" }, 1000 )
  tutorialTop.animate({ backgroundColor: "rgb(59, 74, 84)" }, 1000 )
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
  window.advancedTut = true
  statusMarker.prevAll('span').remove()
  statusMarker.nextAll('span').remove()
  leftside.animate({ backgroundColor: "#543B3B" }, 1000 )
  tutorialTop.animate({ backgroundColor: "#3F2626" }, 1000 )
  advancedTag.fadeIn()

  marker = statusMarker.clone()
  marker.prependTo(progressIndicator)
  marker.title = 'Go back to the Basic Tutorial'

  marker.attr("id", "marker-" + 'BSC')
  marker.find('text').get(0).textContent = '←'
  marker.click( ->switchToBasic() )
  marker.removeClass("active")

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
###if (window.location.hash)
  try
    currentquestion = window.location.hash.split('#')[1].toNumber()
#    questions[currentquestion]()
#    current_question = currentquestion
    next(currentquestion)

  catch err
    questions[0]()
else
  questions[0]()###

$('#results').hide()
