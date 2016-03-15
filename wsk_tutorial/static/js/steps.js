// Generated by CoffeeScript 1.10.0

/*
  This is the main script file. It can attach to the terminal
 */

(function() {
  var COMPLETE_URL, EVENT_TYPES, adv_q, advancedTag, buildfunction, current_question, drawStatusMarker, endsWith, f, isNumber, j, leftside, len, logEvent, next, previous, progressIndicator, q, question, questionNumber, questions, results, staticDockerPs, statusMarker, switchToAdvanced, switchToBasic, tutorialTop;

  COMPLETE_URL = "/whats-next/";


  /*
    Array of question objects
   */

  staticDockerPs = "ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS";

  q = [];

  q.push({
    html: "<h3>OpenWhisk Getting started</h3>\n<p>OpenWhisk is an event-driven compute platform that executes code in response to events or direct invocations.\n</p>\n<p>Examples of events include changes to database records, IoT sensor readings that exceed a certain temperature, new code commits to a GitHub repository, or simple HTTP requests from web or mobile apps. Events from external and internal event sources are channeled through a trigger, and rules allow actions to react to these events. </p>\n<p>Actions can be small snippets of Javascript or Swift code, or custom binaries embedded in a Docker container. Actions in OpenWhisk are instantly deployed and executed whenever a trigger fires. The more triggers fire, the more actions get invoked. If no trigger fires, no action code is running, so there is no cost.</p>\n<p>In addition to associating actions with triggers, it is possible to directly invoke an action by using the OpenWhisk API, CLI, or iOS SDK. A set of actions can also be chained without having to write any code. Each action in the chain is invoked in sequence with the output of one action passed as input to the next in the sequence.</p>",
    assignment: "<h3>Assignment</h3>\n<p>Use a wsk command to see the full list of accepted arguments</p>\n<p>If you see a list of arguments then you know you that your all set with your wsk client installation. </p>",
    intermediateresults: [
      function() {
        return "<p>Shorcut: Use -h instead of --help</p>";
      }
    ],
    tip: "<p>This emulator provides only a limited set of shell and wsk commands, so some commands may not work as expected</p>",
    command_expected: ['wsk', '--help'],
    result: "<p>Well done! Let's move to the next assignment.</p>"
  });

  q.push({
    html: "<h3>Creating a JavaScript Action</h3>\n<p>Actions encapsulate an actual code to be executed. One can think of an action as a piece of code that runs in response to an event. Actions support multiple language bindings including NodeJS, Swift and arbitrary binary programs encapsulated in Docker Containers. Actions invoke any part of an open ecosystem including existing Bluemix services for analytics, data, cognitive, or any other 3rd party service. </p>",
    assignment: "<h3>Assignment</h3>\n<p>Create an action called \"hello\" from the content of the \"hello.js\" file. Use the verbose switch to examine api calls. For this assignment, the file 'hello.js' had been already created. Perform \"cat hello.js\" to examine the contents of the file</p>",
    command_expected: ['wsk', 'action', 'create', 'hello', 'hello.js'],
    result: "<p>You found it! Way to go!</p>",
    tip: "Use wsk --help to examine arguments usages"
  });

  q.push({
    html: "<h3>List actions that have been created. </h3>\n<p>Existing and newly created actions can be looked up by using a wsk command.</p>",
    assignment: "<h3>Assignment</h3>\n<p>List the actions you have created</p>",
    command_expected: ['wsk', 'action', 'list'],
    result: "<p>Cool. Look at the result. You'll see that the action created in step 1 was listed</p>"
  });

  q.push({
    html: "<h3>Running an action using a blocking invocation</h3>\n<p>After you create your action, you can run it in the cloud in OpenWhisk with the 'invoke' command. You can invoke actions with a blocking\ninvocation or a non-blocking invocation by specifying a flag in the command. A blocking invocation waits until the action runs to completion and\nreturns a result. This example uses blocking invocation.</p>",
    assignment: "<h3>Assignment</h3>\n<p>Invoke the hello action utilizing blocking invocation.  </p>",
    command_expected: ['wsk', 'action', 'invoke', '--blocking', 'hello'],
    command_show: ['wsk', 'action', 'invoke', '--blocking', 'hello'],
    result: "<p>Great! The command outputs two important pieces of information:\nThe activation ID (44794bd6aab74415b4e42a308d880e5b)\nThe invocation result. The result in this case is the string Hello world \nreturned by the JavaScript function. The activation ID can be used to \nretrieve the logs or result of the invocation at a future time.",
    intermediateresults: [
      function() {
        return "<p>You seem to be almost there. Did you feed in the \"wsk action\" command \"invoke --blocking hello\" parameters?";
      }
    ],
    tip: "<ul>\n   <li>Remember to use wsk action command.</li>\n</ul>"
  });

  q.push({
    html: "<h3>Running an action using a non-blocking invocation</h3>\n<p>If you don't need the action result right away, you can omit the --blocking flag to make a non-blocking invocation. You can get the result later by using the activation ID. </p>",
    assignment: "<h3>Assignment</h3>\n<p>Invoke the \"hello\" action utilizing non-blocking invocation.  </p>",
    command_expected: ['wsk', 'action', 'invoke', 'hello'],
    command_show: ['wsk', 'action', 'invoke', 'hello'],
    result: "<p>Great! Action was invoked. Next we are going to obtain the result",
    intermediateresults: [
      function() {
        return "<p>You seem to be almost there. Did you feed in the wsk action command \"invoke hello\" parameters";
      }
    ],
    tip: "<ul>\n  <li>Remember to use wsk action</li>\n</ul>"
  });

  q.push({
    html: "<h3>Get action's invocation result using the activation ID</h3>\n<p>You can get an actions result by using the action activation ID. If you forgot to record the activation ID, you can get a list of activations ordered from most recent to the oldest running the <code> wsk activation list</code> command </p>",
    assignment: "<h3>Assignment</h3>\n<p>Obtain a non-blocking action's result.  Remember, a non-blocking invocation may execute in the background so obtaining the result requires the activation ID</p>",
    command_expected: ["wsk", "activation", "result", "6bf1f670ee614a7eb5af3c9fde813043"],
    command_show: ["wsk", "activation", "result", "6bf1f670ee614a7eb5af3c9fde813043"],
    result: "<p>Great! Action was invoked. Next we are going to obtain the result",
    intermediateresults: [
      function() {
        return "<p>You seem to be almost there. Did you feed in the wsk action command \"list\" parameter and the activation ID";
      }
    ],
    tip: "<ul>\n   <li>You need to use the activation result command and supply the activation ID</li>\n</ul>"
  });


  /*
    Array of ADVANCED question objects
   */

  adv_q = [];

  adv_q.push({
    html: "<h3>Volumes</h3>\n<p>A data volume is a specially-designated directory within one or more containers that bypasses the Union File System. Data volumes provide several useful features for persistent or shared data:</p>\n<ul>\n  <li>Volumes are initialized when a container is created. If the container's base image contains data at the specified mount point, that data is copied into the new volume.</li>\n  <li>Data volumes can be shared and reused among containers.</li>\n  <li>Changes to a data volume are made directly.</li>\n  <li>Changes to a data volume will not be included when you update an image.</li>\n  <li>Data volumes persist even if the container itself is deleted.</li>\n</ul>\n<p>Data volumes are designed to persist data, independent of the container's life cycle. Docker therefore never automatically delete volumes when you remove a container,\nnor will it \"garbage collect\" volumes that are no longer referenced by a container.</p>",
    assignment: "<h3>Assignment</h3>\n<p>In this exercise we will create a Volume on our Bluemix org so that it can be bound to containers.</p>\n<p>Go ahead and use the <code>ice volume</code> commands to create a volume named <b>storage</b></p>",
    command_expected: ['ice', 'volume', 'create', 'storage'],
    tip: "<ul>\n  <li>Use <code>ice volume list</code> to list images</li>\n  <li>Use <code>ice volume -h</code> to see all the available commands</li>\n</ul>",
    result: "<p>Sweeet! now we're ready to bind a volume to a running container!</p>",
    currentIcePs: "\nContainer Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports\n"
  });

  adv_q.push({
    html: "<h3>Attaching Volumes</h3>\n<p>Volumes are attached to containers in the run command by using the <code>--volume VolumeId:ContainerPath[:ro]</code> flag/</p>\n<p>The Volume Id is the volume's name (in our example 'storage'), the container path is the directory inside the container that the\nattached volume will mount. This means that all the data written to the specified container path will be stored on the Volume. If the </p>\n<p>There is an optional arguement for granting permissions [:ro] (read only). If not specified the Volume will default to :rw (read write).</p>",
    assignment: "<h3>Assignment</h3>\n<p>Use the <code>ice run</code> command to run a container named <b>iceVolume</b>, running the ibmnode image. Attach the <b>storage</b> volume to the /var/images directory.</p>",
    command_expected: ['ice', 'run', '--name', 'iceVolume', '--volume', 'storage:/var/images', 'ibmnode'],
    result: "<p>You did it! Way to go!</p>",
    tip: "<ul>\n  <li>use <code>ice run -h</code> to see the detailed flag details.</li>\n  <li>Note: the ice cli allows you to use -v and -n as equivalents to --volume and --name however this tutorial enforces the use of the long flag names.</li>\n</ul>",
    intermediateresults: [
      function() {
        return "Don't forget to name your container!";
      }, function() {
        return "Almost! looks like something was wrong with how you attached your volume.";
      }
    ],
    currentIcePs: "\nContainer Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports\n\ndc3ced78-61ed-4870-b668-411c87d2419d iceVolume                         ibmnode:latest                 Apr 30 10:18 Running                                    []"
  });

  adv_q.push({
    html: "<h3>Binding Apps to Bluemix</h3>\n<p>You may already have applications running on Bluemix. Maybe these apps have services bound to them. These services could include things\nlike Databases, or APIs. With ice you can take bind existing applications to you container. This gives the bound container access to all\nthe services which are already bound to the app.</p>\n<p>After a bind, all the services will store their connection info and credentials in the <code>VCAP_SERVICES</code> environment variable</p>",
    assignment: "<h3>Assignment</h3>\n<p>For this emulator we have provisioned an application called <b>myDB</b> it is a simple app connected to a MySQL Database, we want this database\nto be accessible from the container.</p>\n<p>start up another container named <b>boundDB</b> on the ibmnode image. Make sure to bind <b>myDB</b></p>",
    command_expected: ['ice', 'run', '--name', 'boundDB', '--bind', 'myDB', 'ibmnode'],
    result: "<p>Whoop! nice job, All the services are now available to you container.</p>",
    tip: "\"\nuse the <code>--bind</code> flag to bind the app.\nnote: the ice command line supports the use of either --bind or -b for binding, but this tutorial enforces the use of the long flag names.",
    intermediateresults: [
      function() {
        return "Don't forget to name your container!";
      }
    ],
    currentIcePs: "\nContainer Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports\n\n0261b157-9390-4e5d-88ad-a73de12aacb0 boundDB                           ibmnode:latest                 Apr 30 14:40 Running  172.12.128.55                   []\ndc3ced78-61ed-4870-b668-411c87d2419d iceVolume                         ibmnode:latest                 Apr 30 10:18 Running  172.12.128.55                   []"
  });

  adv_q.push({
    html: "<h3>Creating Container Groups</h3>\n<p>Bluemix allows you create container groups to load balance your application. You can have a group comprised of 1 or more containers.\nEach container is an exact copy so incoming connections are balanced between containers. This redundancy also gives applications more stability.</p>",
    assignment: "<h3>Assignment</h3>\n<p>use <code>ice create</code> to create a group named <b>myGroup</b></p>",
    command_expected: ['ice', 'group', 'create', '-p', '80', '--name', 'myGroup', 'ibmnode'],
    result: "<p>You found it! Way to go!</p>",
    tip: "<ul>\n  <li>You can use the <code>--auto</code> flag to have Bluemix automatically restart failed instances.</li>\n  <li>You can use the <code>--desired</code> flag to specify the number of instances that you require. The default is 2.</li>\n  <li>Deleting groups is done using <code>ice group rm</code> (not a part of this emulator)</li>\n  <li>it is possible to pass commands to the ice group create command, the command will run on all containers on the group.</li>\n</ul>",
    currentIceGroups: "\nGroup Id                             Name             Status               Created             Updated             Port\n\n8f97d754-e8fc-4128-ba75-f0d8f3a868ce myGroup          CREATE_COMPLETE      2015-04-28T18:57:42                     80",
    intermediateresults: [
      function() {
        return "Don't forget to expose port 80.";
      }, function() {
        return "Make sure to give you group a name, and expose port 80.";
      }
    ],
    currentIcePs: "\nContainer Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports\n\n21c6724d-50e2-43fc-b947-fd76ef26fc2d my-ogvl-7g734rpjvvy... myGroup    ibmnode:latest                 Apr 30 15:28 Running  172.12.128.58                   []\ncfb39cf2-1a38-4ca3-b948-4e5ae2b56dd2 my-ogvl-m5yb5noyrsj... myGroup    ibmnode:latest                 Apr 30 15:28 Running  172.12.128.57                   []\n0261b157-9390-4e5d-88ad-a73de12aacb0 boundDB                           ibmnode:latest                 Apr 30 14:40 Running  172.12.128.55                   []"
  });

  adv_q.push({
    html: "<h3>Working With Routes</h3>\n<p>Before we get too far go ahead, check you running containers with <code>ice ps</code>. you can also check your groups using <code>ice group list</code></p>\n<p>So now we have this group of containers, We could use ice to bind an ip to the group. But we already did that and it would be much more convenient\nto have a route instead of an ip address. Bluemix allows us to bind routes to groups by using the <code>ice route map</code> command</p>",
    assignment: "<h3>Assignment</h3>\n<p>We need to bind a route to <b>myGroup</b>. the hostname will be <b>groupRoute</b> and the domain will be <b>mybluemix.net</b></p>",
    command_expected: ['ice', 'route', 'map', '--hostname', 'groupRoute', '--domain', 'mybluemix.net', 'myGroup'],
    result: "<p>Cool. Look at the results. You'll see that ice has bound a Route to your container!.</p>",
    tip: "<ul>\n<li>use <code>ice route map -h</code> for usage details.</li>\n<li>you can unmap routes using <code>ice route unmap</code> (not a part of this tutorial)</li>\n<li>Your group must have an exposed port inorder for routing to work!</li>\n<li>you will need to use <code>--hostname</code> and <code>--domain</code> to specify the hostname and domain!</li>\n</ul>",
    intermediateresults: [
      function() {
        var data;
        $('#instructions .assignment').hide();
        $('#tips, #command').hide();
        $('#instructions .text').html("<div class=\"complete\">\n  <h3>Congratulations!</h3>\n  <p>You have mastered the <em style=\"color:aquamarine;\">Advanced</em> docker commands!</p>\n  <p><strong>Did you enjoy this tutorial? Share it!</strong></p>\n  <p>\n    <a href=\"mailto:?Subject=Check%20out%20the%20Docker%20interactive%20tutorial!&Body=%20http://ice.mybluemix.net/\"><img src=\"/static/img/email.png\"></a>\n    <a href=\"http://www.facebook.com/sharer.php?u=http://ice.mybluemix.net/\"><img src=\"/static/img/facebook.png\"></a>\n    <a href=\"http://twitter.com/share?url=http://ice.mybluemix.net/&text=%20Check+out+the+docker+tutorial!\"><img src=\"/static/img/twitter.png\"></a>\n  </p>\n  <h3>Your next steps</h3>\n  <ol>\n    <li><a href=\"/news_signup/\" target=\"_blank\" >Register</a> for news and updates on Docker (opens in new window)</li>\n    <li><a href=\"http://twitter.com/docker\" target=\"_blank\" >Follow</a> us on twitter (opens in new window)</li>\n    <li><a href=\"#\" onClick=\"leaveFullSizeMode()\">Close</a> this tutorial, and continue with the rest of the getting started.</li>\n  </ol>\n  <p> - Or - </p>\n  <p>Continue to learn about the way to automatically build your containers from a file. </p><p><a href=\"/learn/dockerfile/\" class='btn btn-primary secondary-action-button'>Start Dockerfile tutorial</a></p>\n\n</div>");
        data = {
          type: EVENT_TYPES.complete
        };
        return logEvent(data);
      }
    ],
    finishedCallback: function() {
      webterm.clear();
      return webterm.echo(myTerminal());
    }
  });

  questions = [];


  /*
    Register the terminal
   */

  this.webterm = $('#terminal').terminal(interpreter, basesettings);

  EVENT_TYPES = {
    none: "none",
    start: "start",
    command: "command",
    next: "next",
    peek: "peek",
    feedback: "feedback",
    complete: "complete"
  };


  /*
    Sending events to the server (disabled for ice tutorial)
   */

  logEvent = function(data, feedback) {
    return console.log(data);
  };


  /*
    Event handlers
   */

  $('#buttonNext').click(function(e) {
    this.setAttribute('disabled', 'disabled');
    console.log(e);
    return next();
  });

  $('#buttonFinish').click(function() {
    return window.open(COMPLETE_URL);
  });

  $('#buttonPrevious').click(function() {
    previous();
    return $('#results').hide();
  });

  $('#leftside').bind('mousewheel', function(event, delta, deltaX, deltaY) {
    this.scrollTop += deltaY * -30;
    return event.preventDefault();
  });

  $('#feedbackSubmit').click(function() {
    var data, feedback;
    feedback = $('#feedbackInput').val();
    data = {
      type: EVENT_TYPES.feedback,
      feedback: feedback
    };
    return logEvent(data, feedback = true);
  });

  $('#fullSizeOpen').click(function() {
    return goFullScreen();
  });

  isNumber = function(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
  };

  this.goFullScreen = function(start) {
    var index;
    window.scrollTo(0, 0);
    console.debug("going to fullsize mode");
    $('.togglesize').removeClass('startsize').addClass('fullsize');
    $('.hide-when-small').css({
      display: 'inherit'
    });
    $('.hide-when-full').css({
      display: 'none'
    });
    if (start === 'adv') {
      switchToAdvanced();
    } else if (start === 'basic') {
      switchToBasic();
    } else if (isNumber(start)) {
      next(start);
    } else if (endsWith(start, 'ADV')) {
      switchToAdvanced();
      index = start.split('-')[0];
      next(index);
    } else {
      next(0);
    }
    webterm.resize();
    return setTimeout(function() {
      return logEvent({
        type: EVENT_TYPES.start
      });
    }, 3000);
  };

  $('#fullSizeClose').click(function() {
    return leaveFullSizeMode();
  });

  this.leaveFullSizeMode = function() {
    console.debug("leaving full-size mode");
    $('.togglesize').removeClass('fullsize').addClass('startsize');
    $('.hide-when-small').css({
      display: 'none'
    });
    $('.hide-when-full').css({
      display: 'inherit'
    });
    return webterm.resize();
  };

  $('#command').click(function() {
    var data;
    if (!$('#commandHiddenText').hasClass('hidden')) {
      $('#commandHiddenText').addClass("hidden").hide();
      $('#commandShownText').hide().removeClass("hidden").fadeIn();
    }
    data = {
      type: EVENT_TYPES.peek
    };
    return logEvent(data);
  });


  /*
    Navigation amongst the questions
   */

  endsWith = function(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
  };

  current_question = 0;

  window.next = next = function(which) {
    var data;
    $('#marker-' + current_question).addClass("complete").removeClass("active");
    if (which === 'ADV') {
      switchToAdvanced();
    } else if (which === '←') {
      switchToBasic();
    } else if (!which && which !== 0) {
      current_question++;
      if (current_question === questions.length) {
        next('ADV');
      }
    } else {
      current_question = which;
    }
    questions[current_question]();
    results.clear();
    this.webterm.focus();
    if (!$('#commandShownText').hasClass('hidden')) {
      $('#commandShownText').addClass("hidden");
      $('#commandHiddenText').removeClass("hidden").show();
    }
    if (window.advancedTut === true) {
      history.pushState({}, "", "#" + current_question + "-ADV");
      window.location.hash = "#" + current_question + "-ADV";
    } else {
      history.pushState({}, "", "#" + current_question);
      window.location.hash = "#" + current_question;
    }
    data = {
      'type': EVENT_TYPES.next
    };
    logEvent(data);
    $('#marker-' + current_question).removeClass("complete").addClass("active");
    $('#question-number').find('text').get(0).textContent = current_question;
    $('#instructions .assignment').show();
    $('#tips, #command').show();
  };

  previous = function() {
    current_question--;
    questions[current_question]();
    results.clear();
    this.webterm.focus();
  };

  results = {
    set: function(htmlText, intermediate) {
      if (intermediate) {
        console.debug("intermediate text received");
        $('#results').addClass('intermediate');
        $('#buttonNext').hide();
      } else {
        $('#buttonNext').show();
      }
      return window.setTimeout((function() {
        $('#resulttext').html(htmlText);
        $('#results').fadeIn();
        return $('#buttonNext').removeAttr('disabled');
      }), 300);
    },
    clear: function() {
      $('#resulttext').html("");
      return $('#results').fadeOut('slow');
    }
  };


  /*
    Transform question objects into functions
   */

  buildfunction = function(question) {
    var _q;
    _q = question;
    return function() {
      console.debug("function called");
      $('#instructions').hide().fadeIn();
      $('#instructions .text').html(_q.html);
      $('#instructions .assignment').html(_q.assignment);
      $('#tipShownText').html(_q.tip);
      if (_q.command_show) {
        $('#commandShownText').html(_q.command_show.join(' '));
      } else {
        $('#commandShownText').html(_q.command_expected.join(' '));
      }
      if (_q.currentDockerPs != null) {
        window.currentDockerPs = _q.currentDockerPs;
      } else {
        window.currentDockerPs = staticDockerPs;
      }
      if (_q.currentLocalImages != null) {
        window.currentLocalImages = _q.currentLocalImages;
      }
      if (_q.currentCloudImages != null) {
        window.currentCloudImages = _q.currentCloudImages;
      }
      if (_q.currentCloudImages != null) {
        window.currentCloudImages = _q.currentCloudImages;
      }
      if (_q.currentIceGroups != null) {
        window.currentIceGroups = _q.currentIceGroups;
      }
      if (_q.currentIcePs != null) {
        window.currentIcePs = _q.currentIcePs;
      } else {
        window.finishedCallback = function() {
          return "";
        };
      }
      window.immediateCallback = function(input, stop) {
        var data, doNotExecute;
        if (stop === true) {
          doNotExecute = true;
        } else {
          doNotExecute = false;
        }
        if (doNotExecute !== true) {
          console.log(input);
          data = {
            'type': EVENT_TYPES.command,
            'command': input.join(' '),
            'result': 'fail'
          };
          if (input.containsAllOfTheseParts(_q.command_expected)) {
            data.result = 'success';
            setTimeout((function() {
              this.webterm.disable();
              return $('#buttonNext').focus();
            }), 1000);
            results.set(_q.result);
            console.debug("contains match");
          } else {
            console.debug("wrong command received");
          }
          logEvent(data);
        }
      };
      window.intermediateResults = function(input) {
        var intermediate;
        if (_q.intermediateresults) {
          return results.set(_q.intermediateresults[input](), intermediate = true);
        }
      };
    };
  };

  statusMarker = $('#progress-marker-0');

  progressIndicator = $('#progress-indicator');

  leftside = $('#leftside');

  tutorialTop = $('#tutorialTop');

  advancedTag = $('#advancedTag');

  window.switchToBasic = switchToBasic = function() {
    var f, j, len, question, questionNumber;
    window.advancedTut = false;
    questions = [];
    statusMarker.prevAll('span').remove();
    statusMarker.nextAll('span').remove();
    leftside.animate({
      backgroundColor: "#26343f"
    }, 1000);
    tutorialTop.animate({
      backgroundColor: "rgb(59, 74, 84)"
    }, 1000);
    advancedTag.fadeOut();
    questionNumber = 0;
    for (j = 0, len = q.length; j < len; j++) {
      question = q[j];
      f = buildfunction(question);
      questions.push(f);
      drawStatusMarker(questionNumber);
      if (questionNumber > 0) {
        $('#marker-' + questionNumber).removeClass("active").removeClass("complete");
      } else {
        $('#marker-' + questionNumber).removeClass("complete").addClass("active");
      }
      questionNumber++;
    }
    drawStatusMarker('ADV');
    return next(0);
  };

  window.switchToAdvanced = switchToAdvanced = function() {
    var f, j, len, marker, question, questionNumber;
    questions = [];
    window.advancedTut = true;
    statusMarker.prevAll('span').remove();
    statusMarker.nextAll('span').remove();
    leftside.animate({
      backgroundColor: "#543B3B"
    }, 1000);
    tutorialTop.animate({
      backgroundColor: "#3F2626"
    }, 1000);
    advancedTag.fadeIn();
    marker = statusMarker.clone();
    marker.prependTo(progressIndicator);
    marker.title = 'Go back to the Basic Tutorial';
    marker.attr("id", "marker-" + 'BSC');
    marker.find('text').get(0).textContent = '←';
    marker.click(function() {
      return switchToBasic();
    });
    marker.removeClass("active");
    questionNumber = 0;
    for (j = 0, len = adv_q.length; j < len; j++) {
      question = adv_q[j];
      f = buildfunction(question);
      questions.push(f);
      drawStatusMarker(questionNumber);
      if (questionNumber > 0) {
        $('#marker-' + questionNumber).removeClass("active").removeClass("complete");
      } else {
        $('#marker-' + questionNumber).removeClass("complete").addClass("active");
      }
      questionNumber++;
    }
    return next(0);
  };

  drawStatusMarker = function(i) {
    var marker;
    if (i === 0) {
      marker = statusMarker;
    } else {
      marker = statusMarker.clone();
      marker.appendTo(progressIndicator);
    }
    marker.attr("id", "marker-" + i);
    marker.find('text').get(0).textContent = i;
    return marker.click(function() {
      return next(i);
    });
  };

  questionNumber = 0;

  for (j = 0, len = q.length; j < len; j++) {
    question = q[j];
    f = buildfunction(question);
    questions.push(f);
    drawStatusMarker(questionNumber);
    questionNumber++;
  }

  drawStatusMarker('ADV');


  /*
    Initialization of program
   */


  /*if (window.location.hash)
    try
      currentquestion = window.location.hash.split('#')[1].toNumber()
   *    questions[currentquestion]()
   *    current_question = currentquestion
      next(currentquestion)
  
    catch err
      questions[0]()
  else
    questions[0]()
   */

  $('#results').hide();

}).call(this);
