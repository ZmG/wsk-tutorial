###
  Array of ADVANCED question objects
###

adv_q = []
adv_q.push ({
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

switchToAdvanced = () -> 
  
  questionNumber = 0
  for question in q
    f = buildfunction(question)
    questions.push(f)
    drawStatusMarker(questionNumber)
    questionNumber++
