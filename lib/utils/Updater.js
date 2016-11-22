import Notifier from 'update-notifier';
import inquirer from 'inquirer';
import ora from 'ora';

const spawn = require('child_process').spawn;

const UPDATE_INTERVAL = 1;

class Updater {
  constructor(pkg) {
    this.notifier = new Notifier({
      pkg,
      defer: false,
      updateCheckInterval: UPDATE_INTERVAL,
    });
  }

  async verify() {
    if (this.notifier.update) {
      this.notifier.notify({ defer: false });

      const answer = await this.promptUpdate();

      if (answer.shouldUpdate) {
        this.updatePackage();
      }
    }
  }

  async promptUpdate() {
    return inquirer.prompt([{
      message: 'Oops, it looks like you are running an outdated version. Do you want to install latest update? ',
      type: 'confirm',
      name: 'shouldUpdate',
    }]);
  }

  updatePackage() {
    const cmd = spawn('npm', ['-g', 'install', 'plasmatic-cli']);
    const progress = ora({ text: `Updating plasmatic-cli ${this.notifier.update.current} → ${this.notifier.update.latest}` }).start();
    cmd.stdout.on('data', () => {});
    cmd.stderr.on('data', () => {});

    cmd.on('close', (code) => {
      if (code > 0) {
        progress.text = `Installation failed with code ${code}`;
        progress.fail();
      } else {
        progress.text = 'Installation succeed please restart your app!';
        progress.succeed();
      }

      process.exit(code);
    });
  }
}

export default Updater;
