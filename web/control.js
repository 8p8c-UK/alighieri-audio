const mqtt = require('mqtt');
const client = mqtt.connect('mqtt://192.168.1.1', {
    username: 'control_user',
    password: 'control_pass'
});

client.on('connect', () => {
    client.subscribe('alighieri/control/#', (err) => {
        console.log('Alighieri control active');
    });
    client.subscribe('alighieri/status/#', (err) => {
        console.log('Monitoring PTP/streams');
    });
});

client.on('message', (topic, message) => {
    if (topic.startsWith('alighieri/status')) {
        document.getElementById('status').innerText = `${topic}: ${message}`;
    }
});

document.getElementById('volume').addEventListener('input', (e) => {
    client.publish('alighieri/control/volume', e.target.value);
});
document.getElementById('route').addEventListener('click', () => {
    client.publish('alighieri/control/route', 'umc1820-to-aes67');
});
