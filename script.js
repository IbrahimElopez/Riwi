// =============================================
// script.js — Interactividad del portafolio
// =============================================

// --- 1. Mensaje de bienvenida al cargar la página ---
window.addEventListener("load", function () {
  alert("Welcome to Ibrahim's Portfolio!");
});

// --- 2. Botón que cambia el texto del párrafo "About me" ---
const btnChangeText = document.getElementById("btn-change-text");
const aboutText = document.getElementById("about-text");

// Guardamos el texto original para poder alternarlo
const originalText =
  "Hi, my name is Ibrahim Ebratt. I'm 28 years old and I'm from Colombia. I'm a software developer trained by Riwi. I know technologies such as Python, HTML, CSS and GitHub. I'm very social and I speak English and Spanish fluently.";

const funFact =
  "Fun fact: I can write code in Python and HTML at the same time while listening to music!";

// Variable para saber en qué estado estamos
let showingFunFact = false;

btnChangeText.addEventListener("click", function () {
  if (showingFunFact) {
    // Si ya muestra el fun fact, volvemos al texto original
    aboutText.textContent = originalText;
    btnChangeText.textContent = "Show fun fact";
  } else {
    // Si muestra el texto original, cambiamos al fun fact
    aboutText.textContent = funFact;
    btnChangeText.textContent = "Show original text";
  }
  // Alternamos el estado
  showingFunFact = !showingFunFact;
});

// --- 3. Botón que muestra/oculta información extra ---
const btnToggle = document.getElementById("btn-toggle");
const extraInfo = document.getElementById("extra-info");

btnToggle.addEventListener("click", function () {
  if (extraInfo.style.display === "none") {
    // Mostramos el contenido oculto
    extraInfo.style.display = "block";
    btnToggle.textContent = "Hide extra info";
  } else {
    // Ocultamos el contenido
    extraInfo.style.display = "none";
    btnToggle.textContent = "Show extra info";
  }
});



// --- 4. Menú hamburguesa ---
const hamburger = document.getElementById("hamburger");
const mainNav = document.getElementById("main-nav");

hamburger.addEventListener("click", function () {
  // Alterna la clase "open" en el botón y el nav
  hamburger.classList.toggle("open");
  mainNav.classList.toggle("open");
});

// Cierra el menú al hacer clic en un enlace
const navLinks = mainNav.querySelectorAll("a");
navLinks.forEach(function (link) {
  link.addEventListener("click", function () {
    hamburger.classList.remove("open");
    mainNav.classList.remove("open");
  });
});