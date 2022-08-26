#!/usr/bin/env node

const args = process.argv.slice(2)
const {exec} = require('child_process')
const util = require('util')
const execAsync = util.promisify(exec)
const themes = [
  'Bluescreen',
  'Redscreen',
  'Standard',
  'Gotham',
  'Thewebmasterp',
  'Hyper',
]

if (args[0]) {
  if (!themes.includes(args[0])) {
    console.log(`Unexpected argument "${args[0]}"`)
    process.exit()
  }
  // Process input
  //exec(`notify-send ${args[0]}`)
  //switch(args[0]) {}
  const configModules = '/home/master/config-modules/index'
  /* const run = async () => {
    try {
      await execAsync('killall rofi')
      let stdin, stdout
      ;[stdin, stdout] = await execAsync(
        `node ${configModules} --config-modules-dir ~/.config-modules --entry 'dunst-notification' --module ${
          args[0]
        }`
      )
      console.log(stdin, stdout)
      console.log('you kidding me')
      await execAsync(
        `node ${configModules} --config-modules-dir ~/.config-modules --entry 'gtk-widget-toolkit' --module ${
          args[0]
        }`
      )
      await execAsync(
        `node ${configModules} --config-modules-dir ~/.config-modules --entry 'i3-wm' --module ${
          args[0]
        }`
      )
      await execAsync(
        `node ${configModules} --config-modules-dir ~/.config-modules --entry 'rofi-menu' --module ${
          args[0]
        }`
      )
    } catch (e) {
      throw e
    } finally {
      return 'done'
    }
  }
  run().then(data => {
    console.log(data)
  })*/

  exec(
    `node ${configModules} --entry 'alacritty-terminal' --module ${args[0]}.yml`
  )
  exec(`killall rofi`, () => {})
  exec(
    `node ${configModules} --config-modules-dir ~/.config-modules --entry 'dunst-notification' --module ${
      args[0]
    }`
  )
  exec(
    `node ${configModules} --config-modules-dir ~/.config-modules --entry 'gtk-widget-toolkit' --module ${
      args[0]
    }`
  )
  exec(
    `node ${configModules} --config-modules-dir ~/.config-modules --entry 'i3-wm' --module ${
      args[0]
    }`
  )
  exec(
    `node ${configModules} --config-modules-dir ~/.config-modules --entry 'rofi-menu' --module ${
      args[0]
    }`
  )
} else {
  // Print available choices
  themes.forEach(theme => console.log(theme))
}
