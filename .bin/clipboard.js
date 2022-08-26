#!/usr/bin/env node


const {exec} = require('child_process')
//module.paths.push('/usr/lib/node_modules')
//const robot = require('robotjs');
//const { spawn } = require('child_process');

const args = process.argv.slice(2)

// If an argument received
if (args[0]) {
  // Push it to clipboard
  const toBoard = args[0]

  // Paste it after exit
  //const child = spawn('node', ['-e', "module.paths.push('/usr/lib/node_modules'); const robot=require('robotjs'); setTimeout(()=>robot.keyTap('v',['control']),0)"], {detached: true, stdio: 'ignore'})
  //child.unref()
	 
  exec(`echo "${toBoard}" | clipster`, (error, data, getter) => {
    if (error) {
      console.log('error', error.message)
      return
    }
    if (getter) {
      console.log('data', data)
      return
    }
  })
} else {
  //Print available choices
  exec('clipster -n 0 -o -0', (error, data, getter) => {
    if (error) {
      console.log('error', error.message)
      return
    }
    if (getter) {
      console.log('data', data)
      return
    }
    const lines = data.split('\0')
    lines.forEach(line => console.log(line))
  })
}
