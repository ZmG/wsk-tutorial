###
	Please note the javascript is being fully generated from coffeescript.
	So make your changes in the .coffee file.
	Thatcher Peskens
				 _
			,_(')<
			\___)

	Forked and Modified by IBM jStart
###

do @myTerminal = ->

	# Which terminal emulator version are we
	EMULATOR_VERSION = "0.1.5"


	@basesettings = {
		prompt: '[[b;#fff;]you@tutorial:~$] ',
		greetings: """
							 Imitation is the sincerest form of flattery
							 We loved Docker's try it approach - so we forked it
							 Welcome to the IBM Bluemix(tm) Whisk tutorial
							 Courtesy of IBM jStart (http://ibm.com/jstart)

							    ____  __                     _
							   / __ )/ /_  _____  ____ ___  (_)  __
							  / __  / / / / / _ \\/ __ `__ \\/ / |/_/
							 / /_/ / / /_/ /  __/ / / / / / />  <
							/_____/_/\\__,_/\\___/_/ /_/ /_/_/_/|_|

							"""

	}

	###
		Callback definitions. These can be overridden by functions anywhere else
	###

	@preventDefaultCallback = false

	@immediateCallback = (command) ->
		console.debug("immediate callback from #{command}")
		return

	@finishedCallback = (command) ->
		console.debug("finished callback from #{command}")
		return

	@intermediateResults = (string) ->
		console.debug("sent #{string}")
		return

	@currentDockerPs = ""

	@currentVolumes = [""]

	@currentIceGroups = """

	Group Id                             Name             Status               Created             Updated             Port
	"""

	@currentIcePs = """

	Container Id                         Name                   Group      Image                          Created      State    Private IP      Public IP       Ports
	"""

	@currentLocalImages = """
    Target is local host. Invoking docker with the given arguments...
    REPOSITORY            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    ubuntu                latest              8dbd9e392a96        4 months ago        131.5 MB (virtual 131.5 MB)
    """
	@currentCloudImages = """
    Image Id                             Created              Image Name

    d0feae99-b91d-4ce3-bcb4-6128886f6968 Mar 23 10:44:59 2015 registry-ice.ng.bluemix.net/ibmliberty:latest
    74831680-1c9c-424e-b8ea-ceede4aa0e40 Mar 23 10:41:24 2015 registry-ice.ng.bluemix.net/ibmnode:latest

    """

	###
		Base interpreter
	###

	@interpreter = (input, term) ->
		input = input.trim()
		inputs = input.split(" ")
		command = inputs[0]

		if term.loginSequence in [1, 2]
			login(term, inputs)

		else if command is 'hi'
			term.echo 'hi there! What is your name??'
			term.push (command, term) ->
				term.echo command + ' is a pretty name'

		else if command is 'shell'
			term.push (command, term) ->
				if command is 'cd'
					bash(term, inputs)
			, {prompt: '> $ '}

		else if command is 'r'
			location.reload('forceGet')

		else if command is '#'
			term.echo 'which question?'

		else if command is 'cd'
			bash(term, inputs)

		else if command is "wsk"
			wsk(term, inputs)

		else if command is "cat"
			cat(term, inputs)

		else if command is "ls"
			term.echo "hello.js"
		else if command is "cd" or command is "pwd"
			term.echo "This is an emulator, not a shell. Try following the instructions."

		else if command is "pull"
			term.echo '[[b;#fff;]some text]'
			wait(term, 5000, true)
			alert term.get_output()

			return

		## finally
		else if command
			term.echo "#{inputs[0]}: command not found"

		immediateCallback(inputs)

	###  =======================================
		Common utils
	=======================================  ###

	String.prototype.beginsWith = (string) ->
		###
		Check if 'this' string starts with the inputstring.
		###
		return(this.indexOf(string) is 0)

	Array.prototype.containsAllOfThese = (inputArr) ->
		###
		This function compares all of the elements in the inputArr
		and checks them one by one if they exist in 'this'. When it
		finds an element to not exist, it returns false.
		###
		me = this
		valid = false

		if inputArr
			valid = inputArr.every( (value) ->
				if me.indexOf(value) == -1
					return false
				else
					return true
			)
		return valid


	Array.prototype.containsAllOfTheseParts = (inputArr) ->
		###
		This function is like containsAllofThese, but also matches partial strings.
		###

		me = this
		if inputArr
			valid = inputArr.every( (value) ->
				for item in me
					# we use string matching, but we want to be sensitive to dashes, because '--login' != 'login'
					itemDashes = (item.match(/--/g) || []).length
					valueDashes = (value.match(/--/g) || []).length
					if item.match(value) and itemDashes >= valueDashes
						return true

				return false
			)
		return valid


	parseInput = (inputs) ->
		command = inputs[1]
		switches = []
		switchArg = false
		switchArgs = []
		imagename = ""
		commands = []
		j = 0

		# parse args
		for input in inputs
			if input.startsWith('-') and imagename == ""
				switches.push(input)
				if switches.length > 0
					if not ['-i', '-t', '-d'].containsAllOfThese([input])
						switchArg = true
			else if switchArg == true
				# reset switchArg
				switchArg = false
				switchArgs.push(input)
			else if j > 1 and imagename == "" and input != 'create'
				# match wrong names
				imagename = input
			else if input is 'create'
				commands.push (input)
			else if imagename != ""
				commands.push (input)
			else
				# nothing?
			j++

		parsed_input = {
			'switches': switches.sortBy(),
			'switchArgs': switchArgs,
			'imageName': imagename,
			'commands': commands,
		}
		return parsed_input


	util_slow_lines = (term, paragraph, keyword, finishedCallback) ->

		if keyword
			lines = paragraph(keyword).split("\n")
		else
			lines = paragraph.split("\n")

		term.pause()
		i = 0
		# function calls itself after timeout is done, untill
		# all lines are finished
		foo = (lines) ->
			self.setTimeout ( ->
				if lines[i]
					term.echo (lines[i])
					i++
					foo(lines)
				else
					term.resume()
					finishedCallback(term)
			), 1000

		foo(lines)



	wait = (term, time, dots) ->
		term.echo "starting to wait"
		interval_id = self.setInterval ( -> dots ? term.insert '.'), 500

		self.setTimeout ( ->
			self.clearInterval(interval_id)
			output = term.get_command()
			term.echo output
			term.echo "done "
		), time

	###
		Bash program
	###

	bash = (term, inputs) ->
		echo = term.echo
		insert = term.insert

		if not inputs[1]
			console.log("none")

		else
			argument = inputs[1]
			if argument.beginsWith('..')
				echo "-bash: cd: #{argument}: Permission denied"
			else
				echo "-bash: cd: #{argument}: No such file or directory"
	
	#---------------------------------------------------------------------------------------
	#---------------------------------------------------------------------------------------
	#  WSK  I N T E R P R E T E R   --------------------------------------------------------
	#---------------------------------------------------------------------------------------
	#---------------------------------------------------------------------------------------
	cat = (term, inputs) ->
		echo = term.echo
		if inputs[1] is "hello.js"
			echo wsk_cat_helloWorld			

	wsk = (term, inputs) ->

		echo = term.echo
		insert = term.insert
		callback = () -> @finishedCallback(inputs)
		command = inputs[1]

		# no command
		if not inputs[1]
			console.debug "no args"
			echo wsk_no_args

		else if inputs[1] is "--help" or inputs[1] is "-h"
			echo wsk_help
		else if inputs[1] is not "--help" or inputs[1] is not "-h"
			intermediateResults(0)
			echo wsk_invalid_choice

		else if inputs[1] is "action"
			if inputs[2] is "create"
				if inputs[3] is "hello"
					if inputs[4] is "hello.js"
						echo wsk_create_action_hello
				if inputs[3] is "myAction"
					if inputs[4] is "--sequence"
						if inputs[5] is "/whisk.system/util/cat,/whisk.system/util/sort"
							echo wsk_create_action_sequence
						else
							echo wsk_unrecognized_arguments
			else if inputs[2] is "list"
				echo wsk_list_action_hello
			else if inputs[2] is "invoke" 
				if inputs[3] is "hello"
					echo wsk_action_invoke_hello
				else if inputs[3] is "--blocking"
					if inputs[4] is "hello"
						echo wsk_action_invoke_blocking_hello
				else 
					echo wsk_no_args

		else if inputs[1] is "package"
			if inputs[2] is "get"
				if inputs[3] is "--summary"
					if inputs[4] is "/whisk.system/util"
						echo wsk_package_get

		else if inputs[1] is "activation"
			if inputs[2] is "result"
				if inputs[3] is "6bf1f670ee614a7eb5af3c9fde813043"
					echo wsk_activation_result
			else if inputs[2] is "list"
				echo wsk_activation_list

		else if inputs[1] is "-v"
			if inputs[2] is "action"
				if inputs[3] is "create"
					if inputs[4] is "hello"
						if inputs[5] is "hello.js"
							echo wsk_create_action_hello_v

		else if inputs[1] is "images"
			echo currentCloudImages
			
	#---------------------------------------------------------------------------------------
	#---------------------------------------------------------------------------------------
	#  WSK  C O N T E N T    ---------------------------------------------------------------
	#---------------------------------------------------------------------------------------
	#---------------------------------------------------------------------------------------
		
	wsk_help = \
		"""
		usage: wsk [-h] [-v] [--apihost hostname] [--apiversion version]
           {action,activation,namespace,package,rule,trigger,sdk,property,list}
           ...

		OpenWhisk is a distributed compute service to add event-driven logic to your
		apps.

		optional arguments:
		  -h, --help            show this help message and exit
		  -v, --verbose         verbose output
		  --apihost hostname    whisk API host
		  --apiversion version  whisk API version

		available commands:
		  {action,activation,namespace,package,rule,trigger,sdk,property,list}
		    action              work with actions
		    activation          work with activations
		    namespace           work with namespaces
		    package             work with packages
		    rule                work with rules
		    trigger             work with triggers
		    sdk                 work with the SDK
		    property            work with whisk properties
		    list                list all triggers, actions, and rules in the registry

		Learn more at https://developer.ibm.com/openwhisk fork on GitHub
		https://github.com/openwhisk. All trademarks are the property of their
		respective owners.
		"""
	wsk_invalid_choice = \
		"""
		usage: wsk [-h] [-v] [--apihost hostname] [--apiversion version]
           {action,activation,namespace,package,rule,trigger,sdk,property,list}
           ...
		wsk: error: argument cmd: invalid choice: (choose from 'action', 'activation', 'namespace', 'package', 'rule', 'trigger', 'sdk', 'property', 'list')
		"""


	wsk_cat_helloWorld = \
		"""
		function main(params) {
   			return {payload:  'Hello world'};
		}
		"""

	wsk_create_action_hello = \
		"""
		ok: created action hello1
		"""
	wsk_create_action_hello_v = \
		"""
		{'apihost': 'openwhisk.ng.bluemix.net', 'namespace': 'jstart', 'clibuild': '2016-03-03T09:55:47-06:00', 'apiversion': 'v1'}
		========
		REQUEST:
		PUT https://openwhisk.ng.bluemix.net/api/v1/namespaces/jstart/actions/hello
		Headers sent:
		{
		    "Authorization": "Basic 
		     UyLWJJkYu65JKhu7YjM0ZDcwODhlNzBiOmlFS3RWMHl0UWdIT1SxUGNrMUFJRHUzSF2VlFSV53hDUnZlVXhyMGJpbTBGeH827=",
		    "Content-Type": "application/json"
		}
		Body sent:
		{"exec": {"kind": "nodejs", "code": "function main(params) {\n   return {payload:  'Hello, ' + params.name + ' from ' + params.place};\n}\n\n"}}
		--------
		RESPONSE:
		Got response with code 200
		Body received:
		{
		  "name": "hello",
		  "publish": false,
		  "annotations": [],
		  "version": "0.0.1",
		  "exec": {
		    "kind": "nodejs",
		    "code": "function main(params) {\n   return {payload:  'Hello, ' + params.name + ' from ' + params.place};\n}\n\n"
		  },
		  "parameters": [],
		  "limits": {
		    "timeout": 60000,
		    "memory": 256
		  },
		  "namespace": "jstart"
		}
		========
		ok: created action hello
		"""

	wsk_list_action_hello = \ 
		"""
		actions
		hello                                             private
		"""

	wsk_action_invoke_hello = \
		"""
		ok: invoked hello with id 6bf1f670ee614a7eb5af3c9fde813043
		"""

	wsk_action_invoke_blocking_hello = \
		"""
		ok: invoked hello with id 44794bd6aab74415b4e42a308d880e5b
		response:
		{
		   "result": {
		       "payload": "Hello world"
		   },
		   "status": "success",
		   "success": true
		}
		"""

	wsk_activation_result = \
		"""
		{
			"payload" : "Hello world"
		}
		"""

	wsk_activation_list = \
		"""
		activations
		44794bd6aab74415b4e42a308d880e5b         hello
		6bf1f670ee614a7eb5af3c9fde813043         hello
		"""

	wsk_no_args = \
	"""
	usage: wsk [-h] [-v] [--apihost hostname] [--apiversion version]
           {action,activation,namespace,package,rule,trigger,sdk,property,list}
           ...
	wsk: error: too few arguments
	"""

	wsk_create_action_sequence = \
	"""
	ok: created action myAction
	"""

	wsk_unrecognized_arguments = \
	"""
	usage: wsk [-h] [-v] [--apihost hostname] [--apiversion version]
           {action,activation,namespace,package,rule,trigger,sdk,property,list}
           ...
	wsk: error: unrecognized arguments
	"""

	wsk_package_get = \
	"""
	package /whisk.system/util
	action /whisk.system/util/cat: Concatenate array of strings, and split lines into an array
	action /whisk.system/util/head: Filter first K array elements and discard rest
	action /whisk.system/util/date: Get current date and time
	action /whisk.system/util/sort: Sort array
	"""

return this