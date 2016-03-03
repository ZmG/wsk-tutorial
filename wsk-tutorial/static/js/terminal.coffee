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
							 Welcome to the IBM Bluemix(tm) Container tutorial
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

		else if command is 'docker'
			term.echo 'This tutorial was created to teach ice commands, the docker functionality has been disabled. Use "ice --local" instead! (ice --local == docker)'

		else if command is 'cd'
			bash(term, inputs)

		else if command is "ice"
			ice(term, inputs)

else if command is "cf ic"
	cfic(term, inputs)
		else if command is "help"
			term.echo help

		else if command is "ls" or command is "cd" or command is "pwd"
			term.echo "This is an emulator, not a shell. Try following the instructions."

		else if command is "colors"
			for IceCommand, description of IceCommands
				term.echo ("[[b;#fff;]" + IceCommand + "] - " + description + "")

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

	###
		ice login program
	###
	login = (term, inputs) ->

		if term.loginSequence is 1
			term.email = inputs[0]
			term.echo ""
			term.set_prompt "Password> "
			term.loginSequence = 2

		else if term.loginSequence is 2
			util_slow_lines(term, auth, "", loginResult)
			term.loginSequence = 3

			term.set_prompt "[[b;#fff;]you@tutorial:~$] "

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
	#  I C E   I N T E R P R E T E R   -----------------------------------------------------
	#---------------------------------------------------------------------------------------
	#---------------------------------------------------------------------------------------

cfic = (term, inputs) ->
	ice = (term, inputs) ->

		echo = term.echo
		insert = term.insert
		callback = () -> @finishedCallback(inputs)
		command = inputs[1]

		# no command
		if not inputs[1]
			console.debug "no args"
			echo ice_no_args

		else if inputs[1] is "--help" or inputs[1] is "-h"
			console.debug "no args"
			echo ice_help

		else if inputs[1] is "do"
			term.push('do', {prompt: "do $ "})

		else if inputs[1] is "logo"
			echo ICE_logo

		else if inputs[1] is "images"
			echo currentCloudImages

		# Command login
		else if inputs[1] is "login"
			# parse all input so we have a json object
			parsed_input = parseInput(inputs)

			switches = parsed_input.switches
			swargs = parsed_input.switchArgs
			commands = parsed_input.commands

			console.log "commands"
			console.log commands
			console.log "switches"
			console.log switches
			console.log("login")
			if inputs[2] is "-h" or inputs[2] is "--help"
				echo login_cmd
			else if inputs.containsAllOfTheseParts(['ice', 'login'])
				term.echo "API endpoint: https://api.ng.bluemix.net\n"
				term.set_prompt "Email> "
				term.loginSequence = 1

		else if inputs[1] is "version"
			echo ice_version()
		else if inputs[1] is "--version" or inputs[1] is "-version"
			intermediateResults(0)
			echo ice_no_args
		# command ps
		else if inputs[1] is "ps"
			if inputs.containsAllOfThese(['-l'])
				echo ps_l
			else if inputs.containsAllOfThese(['-a'])
				echo ps_a
			else
				echo currentIcePs

		else if inputs[1] is "stop"
			if inputs[2] is "-h" or inputs[2] is "--help"
				echo ice_stop_help
			else if inputs[2] is "ice-ping"
				echo ice_stop_ice_ping
			else if not inputs[2]
				echo ice_stop
			else
				echo ice_no_such_container

		else if inputs[1] is "rm"
			if inputs[2] is "-h" or inputs[3] is "--help"
				echo ice_rm_help
			else if inputs[2] is "ice-ping"
				intermediateResults(0)
				echo ice_rm_ice_ping
			else if not inputs[2]
				echo ice_rm
			else
				echo ice_no_such_container

		else if inputs[1] is "pull"
			intermediateResults(2)
			echo ice_pull

		else if inputs[1] is "inspect"
				if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
					echo inspect_help
				else if inputs[2] and (inputs[2].match('ice-ping') or inputs[2].match('fa2'))
					echo inspect_ice_ping_container
				else if inputs[2]
					echo ice_no_such_container
				else
					echo inspect

		else if inputs[1] is "logs"
				if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
					echo ice_logs_help
				else if inputs[2] and (inputs[2].match('ice-ping') or inputs[2].match('fa2'))
					echo run_ping_localhost
				else if inputs[2]
					echo ice_no_such_container
				else
					echo ice_logs

		else if inputs[1] is "volume"
				if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
					echo ice_volume_help
				else if inputs[2] is 'inspect'
					echo not_implemented(inputs[2])
				else if inputs[2] is 'list'
					if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
						echo ice_volume_list_help
					else
						echo ice_volume_list(currentVolumes)
				else if inputs[2] is 'create'
					if inputs[3] and (inputs[3] is "--help" or inputs[3] is "-h")
						echo ice_volume_create_help
					else if inputs[3]
						currentVolumes.push(inputs[3])
						echo created_volume(inputs[3])
					else
						echo ice_volume_create
				else if inputs[2] is 'rm'
					if inputs[3] and (inputs[3] is "--help" or inputs[3] is "-h")
						echo ice_volume_rm_help
					else if inputs[3]
						index = currentVolumes.indexOf(inputs[3])
						if index > -1
    						currentVolumes.splice(index, 1);
						echo removed_volume
					else
						echo ice_volume_rm
				else
					echo ice_volume

		else if inputs[1] is "group"
				# parse all input so we have a json object
				parsed_input = parseInput(inputs)

				switches = parsed_input.switches
				swargs = parsed_input.switchArgs
				commands = parsed_input.commands
				if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
					echo ice_group_help
				else if inputs[2] is 'inspect' or inputs[2] is 'instances' or inputs[2] is 'update'  or inputs[2] is 'rm'
					echo not_implemented(inputs[2])
				else if inputs[2] is 'list'
					if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
						echo ice_group_list_help
					else
						echo currentIceGroups
				else if inputs[2] is 'create'
					if inputs[3] and (inputs[3] is "--help" or inputs[3] is "-h")
						echo ice_group_create_help
					else if switches.containsAllOfTheseParts(["--name", "-p"]) && swargs.containsAllOfTheseParts(["myGroup", "80"])
						echo group_created
					else if switches.containsAllOfTheseParts(["--name"]) && swargs.containsAllOfTheseParts(["myGroup"])
						intermediateResults(0)
						echo group_created
					else if commands.containsAllOfTheseParts(["create"])
						intermediateResults(1)
						echo group_created
					else
						echo ice_group_create
				else
					echo ice_group

		else if inputs[1] is "route"
				if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
					echo ice_route_help
				else if inputs[2] is 'unmap'
					echo not_implemented(inputs[2])
				else if inputs[2] is 'map'
					if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
						echo ice_route_map_help
					else if inputs[3]
							echo ice_route_mapped
							intermediateResults(0)
					else
						echo ice_route_map
				else echo ice_route


		else if inputs[1] is "ip"
				if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
					echo ice_ip_help
				else if inputs[2] is 'request'
					if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
						echo ice_ip_request_help
					else
						echo ice_ip_request
				else if inputs[2] is 'bind'
					if inputs[3] and (inputs[3] is "--help" or inputs[3] is "-h")
						echo ice_ip_bind_help
					else if inputs[3] is "129.41.232.25" and inputs[4] is "ice-ping"
						echo ice_ip_bound
					else if inputs[3] is "129.41.232.25" and not inputs[4]
						intermediateResults(0)
						echo ice_ip_bind_fail
					else if inputs[3] is "129.41.232.25" and inputs[4] is not "ice-ping"
						intermediateResults(3)
						echo ice_ip_bind_fail
					else if not inputs[3]
						intermediateResults(1)
						echo ice_ip_bind_fail
					else
						intermediateResults(2)
						echo ice_ip_bind_fail
				else
					echo ice_ip

		# Command run
		else if inputs[1] is "run"
			# parse all input so we have a json object
			parsed_input = parseInput(inputs)

			switches = parsed_input.switches
			swargs = parsed_input.switchArgs
			commands = parsed_input.commands
			imagename = parsed_input.imageName

			console.log "commands"
			console.log commands
			console.log "switches"
			console.log switches

			console.log "parsed input"
			console.log parsed_input
			console.log "imagename: #{imagename}"

			if inputs[2] and (inputs[2] is "--help" or inputs[2] is "-h")
				echo ice_run_help

			else if imagename is "ubuntu"
				if switches.containsAllOfTheseParts(['-i', '-t'])
					if commands.containsAllOfTheseParts(['bash'])
						term.push ( (command, term) ->
							if command
								echo """this shell is not implemented. Enter 'exit' to exit."""

						), {prompt: 'root@687bbbc4231b:/# '}
					else
						echo run_image_wrong_command(commands)
				else if commands.containsAllOfTheseParts(['echo'])
					sentence = ''
					for word in commands.slice(1)
    					sentence += word + " "
					echo run_echo(sentence)
				else
					echo run_flag_defined_not_defined(switches)
			else if imagename is "registry-ice.ng.bluemix.net/ibmnode"
				if switches.length = 0
					#missing --local tag
					echo run_learn_no_command
					intermediateResults(0)
				else if commands[0] is "/bin/bash"
					echo run_learn_tutorial_echo_hello_world(commands)
					intermediateResults(2)
				else if commands[0] is "echo"
					echo run_learn_tutorial_echo_hello_world(commands)
				else if commands.containsAllOfThese(['apt-get', 'install', '-y', 'iputils-ping'])
					echo run_apt_get_install_iputils_ping
				else if commands.containsAllOfThese(['apt-get', 'install', 'iputils-ping'])
					echo run_apt_get_install_iputils_ping
				else if commands.containsAllOfThese(['apt-get', 'install', 'ping'])
					echo run_apt_get_install_iputils_ping
				else if commands.containsAllOfThese(['apt-get', 'install'])
					i = commands.length - 1
					echo run_apt_get_install_unknown_package( commands[i] )
				else if commands[0] is "apt-get"
					echo run_apt_get
				else if commands[0]
					echo run_image_wrong_command(commands[0])
				else
					echo run_learn_no_command

			else if imagename is "learn/ping"
				if commands.containsAllOfTheseParts(["ping", "localhost"]) && switches.containsAllOfTheseParts(["--name"]) && swargs.containsAllOfTheseParts(["ice-ping"])
					echo "fa219a32-bcbf-4c6d-977f-1aa67bb1233d"
				else if commands.containsAllOfTheseParts(["ping", "localhost"]) && switches.containsAllOfTheseParts(["-n"]) && swargs.containsAllOfTheseParts(["ice-ping"])
					echo "fa219a32-bcbf-4c6d-977f-1aa67bb1233d"
				else if commands.containsAllOfTheseParts([ "ping", "localhost"]) && (switches.containsAllOfTheseParts(["--name"]) or switches.containsAllOfTheseParts(["-n"]))
					intermediateResults(1)
					echo ice_run_no_name
				else if commands[0] is "ping" and commands[1]
					intermediateResults(0)
					echo run_ping_not_localhost(commands[1])
				else if commands[0] is "ping"
					echo pin
				else if commands[0]
					echo "#{commands[0]}: command not found"
				else
					echo run_learn_no_command

			else if imagename is "ibmnode"
				if switches.containsAllOfTheseParts(["--name", "--volume"]) && swargs.containsAllOfTheseParts(["iceVolume", "storage:/var/images"])
					echo 'dc3ced78-61ed-4870-b668-411c87d2419d'
				else if  switches.containsAllOfTheseParts(["--volume"]) && swargs.containsAllOfTheseParts(["storage:/var/images"])
					intermediateResults(0)
					echo 'h34ced78-61ed-4870-4e5d-a73de12aacb0'
				else if  switches.containsAllOfTheseParts(["--name"]) && swargs.containsAllOfTheseParts(["iceVolume"])
					intermediateResults(1)
					echo 'h34ced78-61ed-4870-4e5d-a73de12aacb0'
				else if switches.containsAllOfTheseParts(["--name", "--bind"]) && swargs.containsAllOfTheseParts(["boundDB", "myDB"])
					echo "0261b157-9390-4e5d-88ad-a73de12aacb0"
				else if switches.containsAllOfTheseParts(["--bind"]) && swargs.containsAllOfTheseParts(["myDB"])
					intermediateResults(0)
					echo "0261b157-9390-4e5d-88ad-a73de12aacb0"
				else if commands.containsAllOfTheseParts([ "ping", "localhost"]) && (switches.containsAllOfTheseParts(["--name"]) or switches.containsAllOfTheseParts(["-n"]))
					intermediateResults(1)
					echo ice_run_no_name
				else if commands[0] is "ping" and commands[1]
					intermediateResults(0)
					echo run_ping_not_localhost(commands[1])
				else if commands[0] is "ping"
					echo ping
				else if commands[0]
					echo "#{commands[0]}: command not found"
				else
					echo run_learn_no_command

			else if imagename
				echo run_notfound(inputs[2])
			else
				console.log("run")
				echo ice_run_help

		#---------------------------------------------------------------------------------------
		#---------------------------------------------------------------------------------------
		#  I C E   L O C A L   C O M M A N D S   -----------------------------------------------
		#---------------------------------------------------------------------------------------
		#---------------------------------------------------------------------------------------

		else if inputs[1] is "--local"
			if inputs[2] is "-h" or inputs[2] is "--help"
				echo docker_cmd
			else if inputs[2] is "pull"
				keyword = inputs[3]
				if inputs[3] is '-h' or inputs is'--help'
					echo pull
				else if not inputs[3]
					echo pull_no_args
				else
					if keyword is 'ubuntu'
						result = util_slow_lines(term, pull_ubuntu, "", callback )
					else if keyword is 'ibmnode'
						intermediateResults(1)
					else if keyword is 'registry-ice.ng.bluemix.net/ibmnode'
						result = util_slow_lines(term, pull_tutorial, "", callback )
					else
						util_slow_lines(term, pull_no_results, keyword)

			# Search
			else if inputs[2] is "search"
				if keyword = inputs[3]
					if keyword is "ubuntu"
						echo search_ubuntu
					else if keyword is "tutorial"
						echo search_tutorial
					else
						echo search_no_results(inputs[3])
				else echo search

			# Command commit
			else if inputs[2] is "commit"
				if inputs[2] is "-h" or inputs[2] is "--help"
					echo commit
				else if inputs.containsAllOfTheseParts(['ice', '--local', 'commit', '698', 'learn/ping'])
					util_slow_lines(term, commit_containerid, "", callback )
				else if inputs.containsAllOfTheseParts(['ice', '--local', 'commit', '698'])
					util_slow_lines(term, commit_containerid, "", callback )
					intermediateResults(0)
				else if inputs.containsAllOfTheseParts(['ice', '--local', 'commit']) and inputs[3]
					echo commit_id_does_not_exist(inputs[3])
				else
					echo commit

			# Command run
			else if inputs[2] is "run"
				# parse all input so we have a json object


				parsed_input = parseInput(inputs)

				switches = parsed_input.switches
				swargs = parsed_input.switchArgs
				imagename = parsed_input.imageName
				commands = parsed_input.commands

				console.log "commands"
				console.log commands
				console.log "switches"
				console.log switches

				console.log "parsed input"
				console.log parsed_input
				console.log "imagename: #{imagename}"

				if imagename is "ubuntu"
					if switches.containsAllOfTheseParts(['-i', '-t'])
						if commands.containsAllOfTheseParts(['bash'])
							term.push ( (command, term) ->
								if command
									echo """this shell is not implemented. Enter 'exit' to exit."""

							), {prompt: 'root@687bbbc4231b:/# '}
						else
							echo run_image_wrong_command(commands)
					else if commands.containsAllOfTheseParts(['echo'])
						sentence = ''
						for word in commands.slice(1)
	    					sentence += word + " "
						echo run_echo(sentence)
					else
						echo run_flag_defined_not_defined(switches)
				else if imagename is "registry-ice.ng.bluemix.net/ibmnode"
					if switches.length = 0
						#missing --local tag TODO
						echo run_learn_no_command
						intermediateResults(0)
					else if commands[0] is "/bin/bash"
						echo run_learn_tutorial_echo_hello_world(commands)
						intermediateResults(2)
					else if commands[0] is "echo"
						echo run_learn_tutorial_echo_hello_world(commands)
					else if commands.containsAllOfThese(['apt-get', 'install', '-y', 'iputils-ping']) or commands.containsAllOfThese(['apt-get', 'install', '-y', 'ping'])
						echo run_apt_get_install_iputils_ping
					else if commands.containsAllOfThese(['apt-get', 'install', 'iputils-ping']) or commands.containsAllOfThese(['apt-get', 'install', 'ping'])
						intermediateResults(0)
						echo run_apt_get_install_iputils_ping
					else if commands.containsAllOfThese(['apt-get', 'install', 'ping'])
						echo run_apt_get_install_iputils_ping
					else if commands.containsAllOfThese(['apt-get', 'install'])
						i = commands.length - 1
						echo run_apt_get_install_unknown_package( commands[i] )
					else if commands[0] is "apt-get"
						echo run_apt_get
					else if commands[0]
						echo run_image_wrong_command(commands[0])
					else
						echo run_learn_no_command

				else if imagename is "learn/ping"
					if commands.containsAllOfTheseParts(["ping", "localhost"])
						util_slow_lines(term, run_ping_localhost, "", callback )
					else if commands[0] is "ping" and commands[1]
						intermediateResults(0)
						echo run_ping_not_localhost(commands[1])
					else if commands[0] is "ping"
						echo ping
					else if commands[0]
						echo "#{commands[0]}: command not found"
					else
						echo run_learn_no_command

				else if imagename
					echo run_notfound(inputs[3])
				else
					console.log("run")
					echo run_cmd

			else if inputs[2] is "images"
				echo currentLocalImages

			else if inputs[2] is "inspect"
				if inputs[3] and inputs[3].match('ef')
					echo inspect_ping_container
				else if inputs[3]
					echo inspect_no_such_container(inputs[3])
				else
					echo inspect

			else if inputs[2] is "tag"
				if inputs[3] is "-h" or inputs[3] is "--help"
					echo tag_help
				else if inputs.containsAllOfTheseParts(["registry-ice.ng.bluemix.net/learn/ping", "learn/ping"])
						echo "Target is local host. Invoking docker with the given arguments..."
				else if inputs.containsAllOfTheseParts(["registry-ice.ng.bluemix.net/learn/ping"])
					intermediateResults(0)
					echo tag_no_args
				else if inputs.containsAllOfTheseParts(["learn/ping"])
					intermediateResults(3)
					echo tag_no_args
				else if inputs.containsAllOfTheseParts(["registry-ice.ng.bluemix.net/ibmnode"])
					intermediateResults(2)
					echo tag_no_args
				else
					intermediateResults(1)
					echo tag_no_args


			# command ps
			else if inputs[2] is "ps"
				if inputs.containsAllOfThese(['-l'])
					echo ps_l
				else if inputs.containsAllOfThese(['-a'])
					echo ps_a
				else
					echo currentDockerPs

			else if inputs[2] is "push"
				if inputs[3] is "-h" or inputs[3] is "--help"
					echo push_help
				else if inputs[3] is "learn/ping"
					intermediateResults(0)
					echo push_wrong_name
				else if inputs[3].match("registry-ice.ng.bluemix.net/learn/ping")
					util_slow_lines(term, push_container_learn_ping, "", callback )
				else if not inputs[3]
					echo push_no_args
				else if inputs[3] is not "http://registry-ice.ng.bluemix.net/learn/ping"
					intermediateResults(0)
				else
					echo push_wrong_name

			else
				echo docker_cmd


		else if IceCommands[inputs[1]]
			echo "#{inputs[1]} is a valid argument, but not implemented"

		else
			echo ice_no_args

		# return empty value because otherwise coffeescript will return last var
		return

	###
		Some default variables / commands

	###
	not_implemented = (command) ->
		"""
		#{command} is a valid argument, but not implemented.
		"""

	ice_help = \
		"""
		usage: ice [-h] [--verbose] [--cloud | --local]
           {login,tlogin,ps,run,inspect,logs,build,start,stop,restart,pause,unpause,rm,images,rmi,search,info,ip,group,route,volume,namespace,help,version,cpi}
           ...

		positional arguments:
		  {login,tlogin,ps,run,inspect,logs,build,start,stop,restart,pause,unpause,rm,images,rmi,search,info,ip,group,route,volume,namespace,help,version,cpi}
		                        cloud commands, for specific command help follow the
		                        command by -h, to list local docker commands run
		                        'docker -h' or 'ice --local -h'
		    login               login to container cloud service
		    tlogin              tenant login, not available for Bluemix Containers
		    ps                  list containers in container cloud
		    run                 create and start container in container cloud
		    inspect             inspect container details
		    logs                get container logs
		    build               build docker image and push to cloud registry
		    start               run existing container
		    stop                stop running container
		    restart             restart running container
		    pause               pause existing container
		    unpause             unpause existing container
		    rm                  remove existing container
		    images              list images registered in container cloud
		    rmi                 remove image from container cloud registry
		    search              search image registry
		    info                display system info
		    ip                  manage floating-ips
		    group               manage auto-scaling groups
		    route               manage routing to container groups
		    volume              manage storage volumes
		    namespace           manage repository namespace
		    help                provide usage help for a specified command
		    version             display program version
		    cpi                 image copy (equivalent to pull, tag, and push)

		optional arguments:
		  -h, --help            show this help message and exit
		  --verbose, -v         display additional debug info
		  --cloud               execute command against container cloud service,
		                        default
		  --local, -L           execute any local docker host command. For list of
		                        available commands run 'docker help'
		"""

	docker_cmd = \
		"""
		Target is local host. Invoking docker with the given arguments...
		Usage: docker [OPTIONS] COMMAND [arg...]

		A self-sufficient runtime for linux containers.

		Options:
		  --api-enable-cors=false                                                Enable CORS headers in the remote API
		  -D, --debug=false                                                      Enable debug mode
		  -d, --daemon=false                                                     Enable daemon mode
		  -G, --group="docker"                                                   Group to assign the unix socket specified by -H when running in daemon mode
		                                                                           use '' (the empty string) to disable setting of a group
		  -H, --host=[]                                                          The socket(s) to bind to in daemon mode or connect to in client mode, specified using one or more tcp://host:port, unix:///path/to/socket, fd://* or fd://socketfd.
		  -h, --help=false                                                       Print usage
		  -l, --log-level="info"                                                 Set the logging level (debug, info, warn, error, fatal)
		  --tls=false                                                            Use TLS; implied by --tlsverify flag
		  --tlscacert="/Users/Pair5/.boot2docker/certs/boot2docker-vm/ca.pem"    Trust only remotes providing a certificate signed by the CA given here
		  --tlscert="/Users/Pair5/.boot2docker/certs/boot2docker-vm/cert.pem"    Path to TLS certificate file
		  --tlskey="/Users/Pair5/.boot2docker/certs/boot2docker-vm/key.pem"      Path to TLS key file
		  --tlsverify=true                                                       Use TLS and verify the remote (daemon: verify client, client: verify daemon)
		  -v, --version=false                                                    Print version information and quit

		Commands:
		    attach    Attach to a running container
		    build     Build an image from a Dockerfile
		    commit    Create a new image from a container's changes
		    cp        Copy files/folders from a container's filesystem to the host path
		    create    Create a new container
		    diff      Inspect changes on a container's filesystem
		    events    Get real time events from the server
		    exec      Run a command in a running container
		    export    Stream the contents of a container as a tar archive
		    history   Show the history of an image
		    images    List images
		    import    Create a new filesystem image from the contents of a tarball
		    info      Display system-wide information
		    inspect   Return low-level information on a container or image
		    kill      Kill a running container
		    load      Load an image from a tar archive
		    login     Register or log in to a Docker registry server
		    logout    Log out from a Docker registry server
		    logs      Fetch the logs of a container
		    port      Lookup the public-facing port that is NAT-ed to PRIVATE_PORT
		    pause     Pause all processes within a container
		    ps        List containers
		    pull      Pull an image or a repository from a Docker registry server
		    push      Push an image or a repository to a Docker registry server
		    rename    Rename an existing container
		    restart   Restart a running container
		    rm        Remove one or more containers
		    rmi       Remove one or more images
		    run       Run a command in a new container
		    save      Save an image to a tar archive
		    search    Search for an image on the Docker Hub
		    start     Start a stopped container
		    stats     Display a live stream of one or more containers' resource usage statistics
		    stop      Stop a running container
		    tag       Tag an image into a repository
		    top       Lookup the running processes of a container
		    unpause   Unpause a paused container
		    version   Show the Docker version information
		    wait      Block until a container stops, then print its exit code

		Run 'docker COMMAND --help' for more information on a command.
		"""

	IceCommands =
		" ": "              For specific command help, follow the command by -h"
		" ": "              To list local docker commands, run 'ice --local -h'"
		" ": "              "
		"login": "          Login to container cloud service"
		"tlogin": "         Tenant login, not available for Bluemix Containers"
		"ps": "             List containers in container cloud"
		"run": "            Create and start container in container cloud"
		"inspect": "        Inspect container details"
		"logs": "           Get container logs"
		"build": "          Build docker image and push to cloud registry"
		"start": "          Run existing container"
		"stop": "           Stop running container"
		"restart": "        Restart running container"
		"pause": "          Pause existing container"
		"unpause": "        Unpause existing container"
		"rm": "             Remove existing container"
		"images": "         List images registered in container cloud"
		"rmi": "            Remove image from container cloud registry"
		"search": "         Search image registry"
		"info": "           Display system info"
		"ip": "             Manage floating-ips"
		"group": "          Manage auto-scaling groups"
		"route": "          Manage routing to container groups"
		"volume": "         Manage storage volumes"
		"namespace": "      Manage repository namespace"
		"help": "           Provide usage help for a specified command"
		"version": "        Display program version"
		"cpi": "            image copy (equivalent to pull, tag, and push)"

	run_switches =
		"-p": ['port']
		"-t": []
		"-i": []
		"-h": ['hostname']

	commit = \
		"""
		Usage: Docker commit [OPTIONS] CONTAINER [REPOSITORY [TAG]]

		Create a new image from a container's changes

			-author="": Author (eg. "John Hannibal Smith <hannibal@a-team.com>"
			-m="": Commit message
			-run="": Config automatically applied when the image is run. (ex: {"Cmd": ["cat", "/world"], "PortSpecs": ["22"]}')
		"""
	tag_success = \
	"""
		Target is local host. Invoking docker with the given arguments...
	"""
	tag_no_args = \
		"""
		Target is local host. Invoking docker with the given arguments...
		docker: "tag" requires 2 arguments. See 'docker tag --help'.
		"""

	tag_help = \
		"""
		Target is local host. Invoking docker with the given arguments...

		Usage: ice --local tag [OPTIONS] IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]

		Tag an image into a repository

		  -f, --force=false    Force
		  --help=false         Print usage
		"""

	commit_id_does_not_exist = (keyword) ->
		"""
		2013/07/08 23:51:21 Error: No such container: #{keyword}
		"""

	commit_containerid = \
		"""
		effb66b31edb
		"""

	auth = \
		"""
		Authenticating...
		OK

		"""

	loginResult = (term) ->
		term.echo (
			"""

			API endpoint:   https://api.ng.bluemix.net (API version: 2.19.0)
			User:           #{term.email}
			Org:            tutorial
			Space:          tutorial
			Authentication with container cloud service at https://api-ice.ng.bluemix.net/v2/containers completed successfully
			You can issue commands now to the container service

			Proceeding to authenticate with the container cloud registry at registry-ice.ng.bluemix.net
			Login Succeeded

			"""
		)

	help = \
		"""
		IBM Container tutorial \n
		\n
		The IBM Container tutorial is an emulater intended to help novice users get up to spead with the IBM Container
		Extension (ice) commands. This terminal contains a limited IBM Container CLI and a limited shell emulator.
		Therefore some of the commands that you would expect do not exist.\n
		\n
		Just follow the steps and questions. If you are stuck, click on the 'expected command' to see what the command
		should have been. Leave feedback if you find things confusing.

		"""



	inspect = \
		"""

		Usage: Docker inspect CONTAINER|IMAGE [CONTAINER|IMAGE...]

		Return low-level information on a container/image

		"""

	ice_route_help = \
	"""
	usage: ice route [-h] {map,unmap} ...

	positional arguments:
	  {map,unmap}  Route management commands for container groups, for specific
	               command help use: ice route <command> -h
	    map        map route
	    unmap      unmap route

	optional arguments:
	  -h, --help   show this help message and exit
	"""

	ice_route_mapped = \
	"""
	Successfully mapped myGroup to groupRoute.mybluemix.net
	"""


	ice_route = \
	"""
	usage: ice route [-h] {map,unmap} ...
	ice route: error: too few arguments
	"""

	ice_route_map = \
	"""
	usage: ice route map [-h] [--hostname HOST] [--domain DOMAIN] GROUP
	ice route map: error: too few arguments
	"""

	ice_route_map_help = \
	"""
	usage: ice route map [-h] [--hostname HOST] [--domain DOMAIN] GROUP

	positional arguments:
	  GROUP                 group id or name

	optional arguments:
	  -h, --help            show this help message and exit
	  --hostname HOST, -n HOST
	                        host name for the route
	  --domain DOMAIN, -d DOMAIN
	                        domain name for the route
	"""

	ice_inspect_help = \
		"""
		usage: ice inspect [-h] CONTAINER

		positional arguments:
		  CONTAINER   container name or id

		optional arguments:
		  -h, --help  show this help message and exit
		"""

	ice_run_help = \
	"""
	usage: ice run [-h] [--name NAME] [--memory MEMORY] [--env ENV]
               [--publish PORT] [--volume VOL] [--bind APP] [--ssh SSHKEY]
               IMAGE [CMD [CMD ...]]

	positional arguments:
	  IMAGE                 image to run
	  CMD                   command & args passed to container to execute

	optional arguments:
	  -h, --help            show this help message and exit
	  --name NAME, -n NAME  assign a name to the container
	  --memory MEMORY, -m MEMORY
	                        memory limit in MB, default is 256
	  --env ENV, -e ENV     set environment variable, ENV is key=value pair
	  --publish PORT, -p PORT
	                        expose PORT
	  --volume VOL, -v VOL  mount volume, VOL is VolumeId:ContainerPath[:ro],
	                        specifying ro makes the volume read-only instead of
	                        the default read-write
	  --bind APP, -b APP    bind to Bluemix app
	  --ssh SSHKEY, -k SSHKEY
	                        ssh key to be injected in container
	"""

	ice_volume = \
	"""
	usage: ice volume [-h] {list,create,rm,inspect} ...
	ice volume: error: too few arguments
	"""

	ice_volume_help = \
	"""
	usage: ice volume [-h] {list,create,rm,inspect} ...

	positional arguments:
	  {list,create,rm,inspect}
	                        Volume management commands, for specific command help
	                        use: ice volume <command> -h
	    list                list volumes
	    create              create volume
	    rm                  remove volume
	    inspect             inspect volume

	optional arguments:
	  -h, --help            show this help message and exit
	"""

	ice_volume_list = () ->
		volString = ''
		for vol in currentVolumes
			volString += vol + "\n"
		return volString

	ice_volume_list_help = \
	"""
	usage: ice volume list [-h]

	optional arguments:
	  -h, --help  show this help message and exit
	"""

	ice_volume_create = \
	"""
	usage: ice volume create [-h] VOLNAME
	ice volume create: error: too few arguments
	"""

	ice_volume_rm = \
	"""
	usage: ice volume rm [-h] VOLNAME
	ice volume rm: error: too few arguments
	"""

	ice_volume_rm_help = \
	"""
	usage: ice volume rm [-h] VOLNAME

	positional arguments:
	  VOLNAME     volume name

	optional arguments:
	  -h, --help  show this help message and exit
	"""

	removed_volume = \
	"""
	Removed volume successfully
	"""

	created_volume = (vol) ->
		"""
		Created volume successfully: #{vol}
		"""

	ice_volume_create_help = \
	"""
	usage: ice volume create [-h] VOLNAME

	positional arguments:
	  VOLNAME     volume name

	optional arguments:
	  -h, --help  show this help message and exit
	"""

	inspect_no_such_container = (keyword) ->
		"""
			Error: No such image: #{keyword}
		"""

	group_created = \
	"""
	28c5997e-8a3d-4e22-9ead-45d30dd2e203
	Created group myGroup (id: 28c5997e-8a3d-4e22-9ead-45d30dd2e203)
	Minimum container instances: 1
	Maximum container instances: 2
	Desired container instances: 2
	"""

	ice_group = \
	"""
	usage: ice group [-h] {list,create,update,rm,inspect,instances} ...
	ice group: error: too few arguments
	"""
	ice_group_help = \
	"""
	usage: ice group [-h] {list,create,update,rm,inspect,instances} ...

	positional arguments:
	  {list,create,update,rm,inspect,instances}
	                        auto-scaling groups management commands, for specific
	                        command help use: ice group <command> -h
	    list                list auto-scaling groups
	    create              create auto-scaling group
	    update              update auto-scaling group size
	    rm                  remove auto-scaling group
	    inspect             inspect group
	    instances           list group instances

	optional arguments:
	  -h, --help            show this help message and exit
	"""

	ice_group_list_help = \
	"""
	usage: ice group list [-h]

	optional arguments:
	  -h, --help  show this help message and exit
	"""


	ice_group_create = \
	"""
	usage: ice group create [-h] [--name NAME] [--memory MEMORY] [--env ENV]
	                        [--publish PORT] [--volume VOL] [--min MIN]
	                        [--max MAX] [--desired DESIRED] [--bind APP] [--auto]
	                        IMAGE [CMD [CMD ...]]
	ice group create: error: too few arguments
	"""

	ice_group_create_help = \
	"""
	Please specify a name for your group using --name or -n option
	"""


	inspect_ice_ping_container = \
	"""

	{
    "BluemixApp": null,
    "Config": {
        "AttachStderr": "",
        "AttachStdin": "",
        "AttachStdout": "",
        "Cmd": [
            "ping",
            "localhost"
        ],
        "Dns": "",
        "Env": [
            "group_id=0000",
            "logging_password=h6Xs4_him67H",
            "tagseparator=_",
            "space_id=73c83834-c956-430c-92c2-3b9b35b6",
            "logstash_target=opvis.bluemix.net:9091",
            "tagformat=space_id group_id uuid",
            "metrics_target=opvis.bluemix.net:9095"
        ],
        "Hostname": "",
        "Image": "registry-ice.ng.bluemix.net/learn/ping:latest",
        "Memory": 256,
        "MemorySwap": "",
        "OpenStdin": "",
        "PortSpecs": "",
        "StdinOnce": "",
        "Tty": "",
        "User": "",
        "VCPU": 1,
        "VolumesFrom": "",
        "WorkingDir": ""
    },
    "ContainerState": "Running",
    "Created": 1429713738,
    "Group": {},
    "HostConfig": {
        "Binds": "null",
        "CapAdd": [],
        "CapDrop": [],
        "ContainerIDFile": "",
        "Links": [],
        "LxcConf": [],
        "PortBindings": {},
        "Privileged": "false",
        "PublishAllPorts": "false"
    },
    "HostId": "9669f466be49e034a72a56362ec824328629f1ec0621f11e73ee8163",
    "Human_id": "ice-ping",
    "Id": "fa219r52-bcbf-4c6d-977f-1aa67bb1233d",
    "Image": "f44c4aa3-c4f0-4476-b670-chgd5363s5f8",
    "Name": "ice-ping",
    "NetworkSettings": {
        "Bridge": "",
        "Gateway": "",
        "IpAddress": "172.4.12.30",
        "IpPrefixLen": 0,
        "PortMapping": "null",
        "PublicIpAddress": ""
    },
    "Path": "date",
    "ResolvConfPath": "/etc/resolv.conf",
    "State": {
        "ExitCode": "",
        "Ghost": "",
        "Pid": "",
        "Running": "false",
        "StartedAt": "",
        "Status": "Shutdown"
    },
    "Volumes": []
	}
	"""

	inspect_ping_container = \
	"""
	[2013/07/30 01:52:26 GET /v1.3/containers/efef/json
	{
		"ID": "efefdc74a1d5900d7d7a74740e5261c09f5f42b6dae58ded6a1fde1cde7f4ac5",
		"Created": "2013-07-30T00:54:12.417119736Z",
		"Path": "ping",
		"Args": [
				"localhost"
		],
		"Config": {
				"Hostname": "efefdc74a1d5",
				"User": "",
				"Memory": 0,
				"MemorySwap": 0,
				"CpuShares": 0,
				"AttachStdin": false,
				"AttachStdout": true,
				"AttachStderr": true,
				"PortSpecs": null,
				"Tty": false,
				"OpenStdin": false,
				"StdinOnce": false,
				"Env": null,
				"Cmd": [
						"ping",
						"localhost"
				],
				"Dns": null,
				"Image": "learn/ping",
				"Volumes": null,
				"VolumesFrom": "",
				"Entrypoint": null
		},
		"State": {
				"Running": true,
				"Pid": 22249,
				"ExitCode": 0,
				"StartedAt": "2013-07-30T00:54:12.424817715Z",
				"Ghost": false
		},
		"Image": "a1dbb48ce764c6651f5af98b46ed052a5f751233d731b645a6c57f91a4cb7158",
		"NetworkSettings": {
				"IPAddress": "172.16.42.6",
				"IPPrefixLen": 24,
				"Gateway": "172.16.42.1",
				"Bridge": "docker0",
				"PortMapping": {
						"Tcp": {},
						"Udp": {}
				}
		},
		"SysInitPath": "/usr/bin/docker",
		"ResolvConfPath": "/etc/resolv.conf",
		"Volumes": {},
		"VolumesRW": {}
	"""

	ping = \
		"""
		Usage: ping [-LRUbdfnqrvVaAD] [-c count] [-i interval] [-w deadline]
						[-p pattern] [-s packetsize] [-t ttl] [-I interface]
						[-M pmtudisc-hint] [-m mark] [-S sndbuf]
						[-T tstamp-options] [-Q tos] [hop1 ...] destination
		"""

	ps = \
		"""
		ID                  IMAGE               COMMAND               CREATED             STATUS              PORTS
		efefdc74a1d5        learn/ping:latest   ping localhost   37 seconds ago      Up 36 seconds
		"""

	ps_a = \
		"""
		ID                  IMAGE               COMMAND                CREATED             STATUS              PORTS
		6982a9948422        ubuntu:12.04        apt-get install ping   1 minute ago        Exit 0
		efefdc74a1d5        learn/ping:latest   ping localhost   37 seconds ago       Up 36 seconds
		"""

	ps_l = \
		"""
		ID                  IMAGE               COMMAND                CREATED             STATUS              PORTS
		6982a9948422        ubuntu:12.04        apt-get install ping   1 minute ago        Exit 0
		"""

	pull = \
		"""
		Usage: docker pull NAME

		Pull an image or a repository from the registry

		-registry="": Registry to download from. Necessary if image is pulled by ID
		-t="": Download tagged image in repository
		"""

	pull_no_args = \
	"""
	Target is local host. Invoking docker with the given arguments...
	docker: "pull" requires 1 argument. See 'docker pull --help'.
	"""

	pull_no_results = (keyword) ->
		"""
		Pulling repository #{keyword}
		2013/06/19 19:27:03 HTTP code: 404
		"""

	pull_ubuntu =
		"""
		Target is local host. Invoking docker with the given arguments...
		Pulling repository ubuntu from https://index.docker.io/v1
		Pulling image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c (precise) from ubuntu
		Pulling image b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc (12.10) from ubuntu
		Pulling image 27cf784147099545 () from ubuntu
		"""

	pull_tutorial = \
		"""
		Target is local host. Invoking docker with the given arguments...
		Pulling repository learn/tutorial from https://index.docker.io/v1
		Pulling image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c (precise) from ubuntu
		Pulling image b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc (12.10) from ubuntu
		Pulling image 27cf784147099545 () from tutorial
		"""

	push_no_args = \
	"""
	Target is local host. Invoking docker with the given arguments...
	docker: "push" requires 1 argument. See 'docker push --help'.
	"""

	push_help = \
		"""
		Usage: docker push [OPTIONS] NAME[:TAG]

		Push an image or a repository to the registry

  		--help=false       Print usage
		"""


	push_container_learn_ping = \
		"""
		Target is local host. Invoking docker with the given arguments...
		The push refers to a repository [registry-ice.ng.bluemix.net/learn/ping] (len: 1)
		Processing checksums
		Sending image list
		Pushing repository learn/ping (1 tags)
		Pushing 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c
		Image 8dbd9e392a964056420e5d58ca5cc376ef18e2de93b5cc90e868a1bbc8318c1c already pushed, skipping
		Pushing tags for rev [662c446b6cdd] on {https://registry-ice.ng.bluemix.net/v1/repositories/learn/ping/tags/latest}
		Pushing a1dbb48ce764c6651f5af98b46ed052a5f751233d731b645a6c57f91a4cb7158
		Pushing  11.5 MB/11.5 MB (100%)
		Pushing tags for rev [a1dbb48ce764] on {https://registry-ice.ng.bluemix.net/v1/repositories/learn/ping/tags/latest}
		"""

	push_wrong_name = \
	"""
	The push refers to a repository [dhrp/fail] (len: 0)
	"""

	login_cmd = \
		"""
		Usage: ice login [OPTIONS] [ARG...]

		Login to the IBM Container Infrastructure

		-h, --help                        show this help message and exit
		--cf                              use Bluemix cf login, default (Bluemix params are used, api key ignored)
		-k API_KEY, --key API_KEY         secret key string (ignored when Bluemix login is used)
		-H HOST, --host HOST              container cloud service host or url
		-R REG_HOST, --registry REG_HOST  container cloud registry host
		-u USER, --user USER              Bluemix user id/email
		-p PSSWD, --psswd PSSWD           Bluemix password
		-o ORG, --org ORG                 Bluemix organization
		-s SPACE, --space SPACE           Bluemix space
		-a API_URL, --api API_URL         Bluemix API Endpoint
		"""

	run_cmd = \
		"""
		Usage: Docker run [OPTIONS] IMAGE COMMAND [ARG...]

		Run a command in a new container

		-a=map[]: Attach to stdin, stdout or stderr.
		-c=0: CPU shares (relative weight)
		-d=false: Detached mode: leave the container running in the background
		-dns=[]: Set custom dns servers
		-e=[]: Set environment variables
		-h="": Container host name
		-i=false: Keep stdin open even if not attached
		-m=0: Memory limit (in bytes)
		-p=[]: Expose a container's port to the host (use 'docker port' to see the actual mapping)
		-t=false: Allocate a pseudo-tty
		-u="": Username or UID
		-v=map[]: Attach a data volume
		-volumes-from="": Mount volumes from the specified container
		"""

	run_apt_get = \
		"""
		apt 0.8.16~exp12ubuntu10 for amd64 compiled on Apr 20 2012 10:19:39
		Usage: apt-get [options] command
					 apt-get [options] install|remove pkg1 [pkg2 ...]
					 apt-get [options] source pkg1 [pkg2 ...]

		apt-get is a simple command line interface for downloading and
		installing packages. The most frequently used commands are update
		and install.

		Commands:
			 update - Retrieve new lists of packages
			 upgrade - Perform an upgrade
			 install - Install new packages (pkg is libc6 not libc6.deb)
			 remove - Remove packages
			 autoremove - Remove automatically all unused packages
			 purge - Remove packages and config files
			 source - Download source archives
			 build-dep - Configure build-dependencies for source packages
			 dist-upgrade - Distribution upgrade, see apt-get(8)
			 dselect-upgrade - Follow dselect selections
			 clean - Erase downloaded archive files
			 autoclean - Erase old downloaded archive files
			 check - Verify that there are no broken dependencies
			 changelog - Download and display the changelog for the given package
			 download - Download the binary package into the current directory

		Options:
			-h  This help text.
			-q  Loggable output - no progress indicator
			-qq No output except for errors
			-d  Download only - do NOT install or unpack archives
			-s  No-act. Perform ordering simulation
			-y  Assume Yes to all queries and do not prompt
			-f  Attempt to correct a system with broken dependencies in place
			-m  Attempt to continue if archives are unlocatable
			-u  Show a list of upgraded packages as well
			-b  Build the source package after fetching it
			-V  Show verbose version numbers
			-c=? Read this configuration file
			-o=? Set an arbitrary configuration option, eg -o dir::cache=/tmp
		See the apt-get(8), sources.list(5) and apt.conf(5) manual
		pages for more information and options.
													 This APT has Super Cow Powers.

		"""

	run_apt_get_install_iputils_ping = \
		"""
			Target is local host. Invoking docker with the given arguments...
			Reading package lists...
			Building dependency tree...
			The following NEW packages will be installed:
				iputils-ping
			0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
			Need to get 56.1 kB of archives.
			After this operation, 143 kB of additional disk space will be used.
			Get:1 http://archive.ubuntu.com/ubuntu/ precise/main iputils-ping amd64 3:20101006-1ubuntu1 [56.1 kB]
			debconf: delaying package configuration, since apt-utils is not installed
			Fetched 56.1 kB in 1s (50.3 kB/s)
			Selecting previously unselected package iputils-ping.
			(Reading database ... 7545 files and directories currently installed.)
			Unpacking iputils-ping (from .../iputils-ping_3%3a20101006-1ubuntu1_amd64.deb) ...
			Setting up iputils-ping (3:20101006-1ubuntu1) ...
		"""

	run_apt_get_install_unknown_package = (keyword) ->
		"""
			Reading package lists...
			Building dependency tree...
			E: Unable to locate package #{keyword}
		"""

	run_flag_defined_not_defined = (keyword) ->
		"""
		2013/08/15 22:19:14 flag provided but not defined: #{keyword}
		"""

	run_learn_no_command = \
		"""
		2013/07/02 02:00:59 Error: No command specified
		"""

	run_learn_tutorial_echo_hello_world = (commands) ->
		string = "Target is local host. Invoking docker with the given arguments...\n"
		for command in commands[1..]
			command = command.replace('"','');
			string += ("#{command} ")
		return string

	run_echo = (echo) ->
		"""
		Target is local host. Invoking docker with the given arguments...
		#{echo}
		"""


	run_image_wrong_command = (keyword) ->
		"""
		2013/07/08 23:13:30 Unable to locate #{keyword}
		"""

	run_notfound = (keyword) ->
		"""
		Pulling repository #{keyword} from https://index.docker.io/v1
		2013/07/02 02:14:47 Error: No such image: #{keyword}
		"""

	run_ping_not_localhost = (keyword) ->
		"""
		ping: unknown host #{keyword}
		"""

	run_ping_localhost = \
		"""
		PING localhost (127.0.0.1) 56(84) bytes of data.
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=1 ttl=55 time=2.23 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=2 ttl=55 time=2.30 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=3 ttl=55 time=2.27 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=4 ttl=55 time=2.30 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=5 ttl=55 time=2.25 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=6 ttl=55 time=2.29 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=7 ttl=55 time=2.23 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=8 ttl=55 time=2.30 ms
		64 bytes from nuq05s02-in-f20.1e100.net (127.0.0.1): icmp_req=9 ttl=55 time=2.35 ms
		-> This would normally just keep going. However, this emulator does not support Ctrl-C, so we quit here.
		"""

	search = \
		"""

		Usage: Docker search NAME

		Search the Docker index for images

		"""

	search_no_results = (keyword) ->
		"""
		Found 0 results matching your query ("#{keyword}")
		NAME                DESCRIPTION
		"""

	search_tutorial = \
		"""
		Found 1 results matching your query ("tutorial")
		NAME                      DESCRIPTION
		learn/tutorial            An image for the interactive tutorial
		"""

	search_ubuntu = \
		"""
		Found 22 results matching your query ("ubuntu")
		NAME                DESCRIPTION
		shykes/ubuntu
		base                Another general use Ubuntu base image. Tag...
		ubuntu              General use Ubuntu base image. Tags availa...
		boxcar/raring       Ubuntu Raring 13.04 suitable for testing v...
		dhrp/ubuntu
		creack/ubuntu       Tags:
		12.04-ssh,
		12.10-ssh,
		12.10-ssh-l...
		crohr/ubuntu              Ubuntu base images. Only lucid (10.04) for...
		knewton/ubuntu
		pallet/ubuntu2
		erikh/ubuntu
		samalba/wget              Test container inherited from ubuntu with ...
		creack/ubuntu-12-10-ssh
		knewton/ubuntu-12.04
		tithonium/rvm-ubuntu      The base 'ubuntu' image, with rvm installe...
		dekz/build                13.04 ubuntu with build
		ooyala/test-ubuntu
		ooyala/test-my-ubuntu
		ooyala/test-ubuntu2
		ooyala/test-ubuntu3
		ooyala/test-ubuntu4
		ooyala/test-ubuntu5
		surma/go                  Simple augmentation of the standard Ubuntu...

		"""

	testing = \
	"""
	Testing leads to failure, and failure leads to understanding. ~Burt Rutan
	"""

	docker_version = () ->
		"""
		Docker Emulator version #{EMULATOR_VERSION}

		Emulating:
		Client version: 0.5.3
		Server version: 0.5.3
		Go version: go1.1
		"""

	ice_no_args = \
	"""
	usage: ice [-h] [--verbose] [--cloud | --local]
           {login,tlogin,ps,run,inspect,logs,build,start,stop,restart,pause,unpause,rm,images,rmi,search,info,ip,group,route,volume,namespace,help,version,cpi}
           ...
	ice: error: too few arguments
	"""

	ice_version = () ->
			"""
			ICE CLI Version        : 2.0.1 271 2015-03-30T15:40:18
			"""

	ice_rm = \
	"""
	usage: ice rm [-h] CONTAINER
	ice rm: error: too few arguments
	"""

	ice_rm_help = \
	"""
	usage: ice rm [-h] CONTAINER

	positional arguments:
	  CONTAINER   container name or id

	optional arguments:
	  -h, --help  show this help message and exit
	"""

	ice_rm_ice_ping = \
	"""
	Removed container successfully
	"""

	ice_stop = \
	"""
	usage: ice stop [-h] [--time SECS] CONTAINER
	ice stop: error: too few arguments
	"""

	ice_stop_help = \
	"""
	usage: ice stop [-h] [--time SECS] CONTAINER

	positional arguments:
	  CONTAINER             container name or id

	optional arguments:
	  -h, --help            show this help message and exit
	  --time SECS, -t SECS  seconds to wait before killing container
	"""

	ice_stop_ice_ping = \
	"""
	Stopped container successfully
	"""

	ice_no_such_container = \
	"""
	Command failed with container cloud service
	no such container
	"""

	ice_pull = \
	"""
	usage: ice [-h] [--verbose] [--cloud | --local]
           {login,tlogin,ps,run,inspect,logs,build,start,stop,restart,pause,unpause,rm,images,rmi,search,info,ip,group,route,volume,namespace,help,version,cpi}
           ...
	ice: error: argument subparser_name: invalid choice: 'pull' (choose from 'login', 'tlogin', 'ps', 'run', 'inspect', 'logs', 'build', 'start', 'stop', 'restart', 'pause', 'unpause', 'rm', 'images', 'rmi', 'search', 'info', 'ip', 'group', 'route', 'volume', 'namespace', 'help', 'version', 'cpi')
	"""

	ice_logs = \
	"""
	usage: ice logs [-h] [--stdout | --stderr] CONTAINER
	ice logs: error: too few arguments
	"""

	ice_logs_help = \
	"""
	usage: ice logs [-h] [--stdout | --stderr] CONTAINER

	positional arguments:
	  CONTAINER     container name or id

	optional arguments:
	  -h, --help    show this help message and exit
	  --stdout, -o  get output log, default
	  --stderr, -e  get error log
	"""

	ice_run_no_name = \
	"""
	Please specify a name for your container using --name or -n option
	"""

	ice_ip = \
	"""
	usage: ice ip [-h] {list,bind,unbind,request,release} ...
	ice ip: error: too few arguments
	"""

	ice_ip_help = \
	"""
	usage: ice ip [-h] {list,bind,unbind,request,release} ...

	positional arguments:
	  {list,bind,unbind,request,release}
	                        floating-ips management commands, for specific command
	                        help use: ice ip <command> -h
	    list                list floating ips, defaults to available only ips
	    bind                bind floating ip to container
	    unbind              unbind floating ip from container
	    request             request a new floating ip
	    release             release floating ip back to general pool

	"""

	ice_ip_bound = \
	"""
	Successfully bound ip
	"""

	ice_ip_bind_fail = \
	"""
	usage: ice ip bind [-h] ADDRESS CONTAINER
	ice ip bind: error: too few arguments
	"""

	ice_ip_bind_help = \
	"""
	usage: ice ip bind [-h] ADDRESS CONTAINER

	positional arguments:
	  ADDRESS     ip address
	  CONTAINER   container id or name

	optional arguments:
	  -h, --help  show this help message and exit
	"""

	ice_ip_request = \
	"""
	Successfully obtained ip: "129.41.232.25"
	"""

	ice_ip_request_help = \
	"""
	usage: ice ip bind [-h] ADDRESS CONTAINER

	positional arguments:
	  ADDRESS     ip address
	  CONTAINER   container id or name

	optional arguments:
	  -h, --help  show this help message and exit
	"""


	ICE_logo = \
	'''
	ttttttttttttttttt1iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiittttttttttttttttttttttttttttttttttttttttttttttttttttttt
	ttttttttttttttttt1iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiittttttttttttttttttttttttttttttttttttttttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	ttttttttttttttttt1iiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiittttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
	tttttttttttttttttiiiiiii:  iiiiii, .iiiiii. .iiiiii  ,iiiiiiiiiiftttttt. .ttttt1  ;ttttt1  ittttti  itttttttttttttttttt
																																						 ,ttt1  ;ttttt1  ittttti  itttttttttttttttttt
																																						 ,ttt1  ;ttttt1  ittttti  itttttttttttttttttt
																																						 ,ttt1  ;ttttt1  ittttti  itttttttttttttttttt
																																						 ,ttt1  ;ttttt1  ittttti  itttttttttttttttttt
									:iiiiii;.   .iiiiiiiii,,iiiiiiiiii   iii                   ,ttttttttttttttttttttttttttttttttttttttttttt
								 .CCLtttLCCf  tCCLLLLLLL fLLLCCCLLLf  LCCC1                  ,ttttttttttttttttttttttttttttttttttttttttttt
								 :CC:   .CCf .CCf           .CCt    .CC11CC                  ,ttttttttttttttttttttttttttttttttttttttttttt
								 LCCCCCCCL,  ;CCCCCCCCf     tCC    .CCi .CC
								:CCi    ;CC: CCL           .CCf   :CCLtttCC1
								tCC    ,LCC.:CC1,,,,,,.    ;CC,  1CC;;;;;CCC                 ,GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
							 .CCCCCCCCL;  fCCCCCCCCC     CCL  LCC.     1CC                 :GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
																																						 :GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
																																						 :GGGG;;fGGGGGC;;LGGGGGL;;LGGGGGGGGGGGGGGGGGG
																																						 :GGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
																																						 :GGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	,,,,,,,,,,,,,,,,,,1iiiii:  1iiiii, .1iiiii. .1iiiii  ,iiiiii    ,LLLLLL. ,LLGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	G:,,,,,,,,,,,,,,,:tttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GG ,,,,,,,,,,,,,,:tttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GGGG:,,,,,,,,,,,,:tttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GGGGGG;;;;;;;;;;;ttttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GGGGGGGGGGGGGGGGGftttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GGGGGGGGGGGGGGGGGftttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GGGGGGGGGGGGGGGGGftttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GGGGGGGGGGGGGGGGGftttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGGGGGGGG
	GGGGGiiiiiiiiiiiiftttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGG1iiiiii
	iiiiiiiiiiiiiiiiiftttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGiiiiiii
	iiiiiiiiiiiiiiiiiftttttt;  tttttt: .tttttt. .tttttt  :tttttttttt0GGGGGG. ,GGGGGC  1GGGGGC  fGGGGGf  LGGGGGGGGGGGiiiiiii
	iiiiiiiiiiiiiiiiiftttttti::tttttt;::tttttt:::tttttt::;tttttttttt0GGGGGGii1GGGGGGiifGGGGGCiiLGGGGGLiiCGGGGGGGGGGGiiiiiii
	iiiiiiiiiiiiiiiiiftttttttttttttttttttttttttttttttttttttttttttttt0GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGiiiiiii
	iiiiiiiiiiiiiiiiiftttttttttttttttttttttttttttttttttttttttttttttt0GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGiiiiiii
	iiiiiiiiiiiiiiiii@tttttttttttttttttttttttttttttttttttttttttffffffGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG000000iiiiiii
	iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii1iiiiii
	iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii
	iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii

	'''


return this
