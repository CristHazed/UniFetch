const menuButton = document.querySelector(".menu-toggle");
const nav = document.querySelector(".main-nav");

menuButton.addEventListener("click", () => {
  const isOpen = nav.classList.toggle("is-open");
  menuButton.setAttribute("aria-expanded", String(isOpen));
});

document.querySelectorAll(".main-nav a").forEach((link) => {
  link.addEventListener("click", () => {
    nav.classList.remove("is-open");
    menuButton.setAttribute("aria-expanded", "false");
  });
});

const canvas = document.getElementById("heroCanvas");
const ctx = canvas.getContext("2d");
let width = 0;
let height = 0;
let animationFrame = 0;

const nodes = [
  { x: 0.16, y: 0.68 },
  { x: 0.28, y: 0.45 },
  { x: 0.44, y: 0.58 },
  { x: 0.58, y: 0.36 },
  { x: 0.75, y: 0.52 },
  { x: 0.86, y: 0.32 }
];

function resizeCanvas() {
  const ratio = window.devicePixelRatio || 1;
  width = canvas.clientWidth;
  height = canvas.clientHeight;
  canvas.width = Math.floor(width * ratio);
  canvas.height = Math.floor(height * ratio);
  ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
}

function drawCampus(time) {
  ctx.clearRect(0, 0, width, height);

  const background = ctx.createLinearGradient(0, 0, width, height);
  background.addColorStop(0, "#251448");
  background.addColorStop(0.44, "#171b42");
  background.addColorStop(1, "#061733");
  ctx.fillStyle = background;
  ctx.fillRect(0, 0, width, height);

  ctx.save();
  ctx.translate(width / 2, height / 2);
  ctx.rotate(-0.08);
  ctx.translate(-width / 2, -height / 2);

  ctx.strokeStyle = "rgba(255,255,255,0.09)";
  ctx.lineWidth = 2;
  const grid = Math.max(78, width / 14);
  for (let x = -grid; x < width + grid; x += grid) {
    ctx.beginPath();
    ctx.moveTo(x, 0);
    ctx.lineTo(x + 120, height);
    ctx.stroke();
  }
  for (let y = -grid; y < height + grid; y += grid) {
    ctx.beginPath();
    ctx.moveTo(0, y);
    ctx.lineTo(width, y - 80);
    ctx.stroke();
  }

  ctx.lineCap = "round";
  ctx.lineJoin = "round";
  ctx.strokeStyle = "rgba(143,232,255,0.36)";
  ctx.lineWidth = 12;
  ctx.beginPath();
  nodes.forEach((node, index) => {
    const x = node.x * width;
    const y = node.y * height;
    if (index === 0) {
      ctx.moveTo(x, y);
    } else {
      ctx.lineTo(x, y);
    }
  });
  ctx.stroke();

  ctx.strokeStyle = "rgba(138,255,207,0.7)";
  ctx.lineWidth = 4;
  ctx.setLineDash([18, 18]);
  ctx.lineDashOffset = -time * 0.08;
  ctx.stroke();
  ctx.setLineDash([]);

  nodes.forEach((node, index) => {
    const x = node.x * width;
    const y = node.y * height;
    const pulse = Math.sin(time * 0.004 + index) * 5;
    ctx.fillStyle = index === nodes.length - 1 ? "#8affcf" : "#8f6cff";
    ctx.beginPath();
    ctx.arc(x, y, 9 + pulse, 0, Math.PI * 2);
    ctx.fill();
  });

  const progress = (Math.sin(time * 0.00055) + 1) / 2;
  const segment = Math.min(nodes.length - 2, Math.floor(progress * (nodes.length - 1)));
  const local = progress * (nodes.length - 1) - segment;
  const current = nodes[segment];
  const next = nodes[segment + 1];
  const driverX = (current.x + (next.x - current.x) * local) * width;
  const driverY = (current.y + (next.y - current.y) * local) * height;

  ctx.fillStyle = "rgba(138,255,207,0.22)";
  ctx.beginPath();
  ctx.arc(driverX, driverY, 44, 0, Math.PI * 2);
  ctx.fill();
  ctx.fillStyle = "#8affcf";
  ctx.beginPath();
  ctx.arc(driverX, driverY, 16, 0, Math.PI * 2);
  ctx.fill();

  ctx.restore();
}

function animate(time) {
  drawCampus(time);
  animationFrame = requestAnimationFrame(animate);
}

window.addEventListener("resize", resizeCanvas);
resizeCanvas();
animationFrame = requestAnimationFrame(animate);
