
// remove inactive particles
while (particles[firstActive].age >= duration && firstActive != firstFree) {
firstActive++;
if (firstActive == particles.length) firstActive = 0;
}


};
ParticlePool.prototype.draw = function(context, image) {
// draw active particles
if (firstActive < firstFree) {
for (i = firstActive; i < firstFree; i++)
particles[i].draw(context, image);
}
if (firstFree < firstActive) {
for (i = firstActive; i < particles.length; i++)
particles[i].draw(context, image);
for (i = 0; i < firstFree; i++)
particles[i].draw(context, image);
}
};
return ParticlePool;
})();

/*
* Putting it all together
*/
(function(canvas) {
var context = canvas.getContext('2d'),
particles = new ParticlePool(settings.particles.length),
particleRate = settings.particles.length / settings.particles.duration, // particles/sec
time;

// get point on heart with -PI <= t <= PI
function pointOnHeart(t) {
return new Point(
160 * Math.pow(Math.sin(t), 3),
130 * Math.cos(t) - 50 * Math.cos(2 * t) - 20 * Math.cos(3 * t) - 10 * Math.cos(4 * t) + 25
);
}

// creating the particle image using a dummy canvas
var image = (function() {
var canvas = document.createElement('canvas'),
context = canvas.getContext('2d');
canvas.width = settings.particles.size;
canvas.height = settings.particles.size;
// helper function to create the path
function to(t) {
var point = pointOnHeart(t);
point.x = settings.particles.size / 2 + point.x * settings.particles.size / 350;
point.y = settings.particles.size / 2 - point.y * settings.particles.size / 350;
return point;
}
// create the path
context.beginPath();
var t = -Math.PI;
var point = to(t);
context.moveTo(point.x, point.y);
while (t < Math.PI) {
t += 0.01; // baby steps!
point = to(t);
context.lineTo(point.x, point.y);
}
context.closePath();
// create the fill
context.fillStyle = '#ea80b0';
context.fill();
// create the image
var image = new Image();
image.src = canvas.toDataURL();
return image;
})();

// render that thing!
function render() {
// next animation frame
requestAnimationFrame(render);

// update time
var newTime = new Date().getTime() / 1000,
deltaTime = newTime - (time || newTime);
time = newTime;

// clear canvas
context.clearRect(0, 0, canvas.width, canvas.height);

// create new particles
var amount = particleRate * deltaTime;
for (var i = 0; i < amount; i++) {
var pos = pointOnHeart(Math.PI - 2 * Math.PI * Math.random());
var dir = pos.clone().length(settings.particles.velocity);
particles.add(canvas.width / 2 + pos.x, canvas.height / 2 - pos.y, dir.x, -dir.y);
}

// update and draw particles
particles.update(deltaTime);
particles.draw(context, image);
var c=document.getElementById("pinkboard");
var ctx=c.getContext("2d");
ctx.fillStyle= "#FF1493";
ctx.font="40px Arial";
ctx.fillText("GOOD LUCK",canvas.width/2-105,canvas.height/2-250);
ctx.fillText("I will always wait for you.",canvas.width/2-200,canvas.height/2+250);
ctx.font="30px Arial";
ctx.fillText("      Happy every day, my dear princess.",canvas.width/2-280,canvas.height/2+300);
}

// handle (re-)sizing of the canvas
function onResize() {
canvas.width = canvas.clientWidth;
canvas.height = canvas.clientHeight;
}
window.onresize = onResize;

// delay rendering bootstrap
setTimeout(function() {
onResize();
render();
}, 10);
})(document.getElementById('pinkboard'));

</script>

</body>
</html>
