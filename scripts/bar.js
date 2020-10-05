const sh = require("/usr/lib/node_modules/shelljs/shell.js");
const argv = process.argv.slice(2);
const notify = msg => sh.exec(`notify-send '${msg}'`);

sh.config.silent = true;

const echo = console.log;

const awesomefontecho = (s, color) => {
    if (color) color = ` color="${color}"`;
    echo(`<span font="Font Awesome 5 Free" rise="-1024"${color}>${s}</span>`);
};

const batt = () => {
    let acpi = sh.exec("acpi -b").trim();
    let percent = acpi.split(", ")[1];
    let charging = !acpi.includes("Discharging");
};

