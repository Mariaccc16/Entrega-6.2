// Librería de sonido
import processing.sound.*;

// Variables globales
int escena = 0;
Campanadas campanadas;
ArrayList<FuegoArtificial> fuegos = new ArrayList<FuegoArtificial>();
boolean fuegosActivos = false;

// Recursos visuales
PImage sala, mesa, uvas, balcon, abrazos, inicio;

// Recursos de sonido
SoundFile campana, polvora, celebracion, musicaFondo;
boolean musicaReproducida = false;

// Fuente personalizada
PFont fuentePersonalizada;

void setup() {
  size(800, 600);
  campanadas = new Campanadas();

  // Cargar imágenes
  sala = loadImage("sala.png");
  mesa = loadImage("mesa.png");
  uvas = loadImage("uvas.png");
  balcon = loadImage("balcón.png");
  abrazos = loadImage("abrazo.png");
  inicio = loadImage("inicio.png");

  // Cargar sonidos
  campana = new SoundFile(this, "campanadas .mp3");
  polvora = new SoundFile(this, "polvora 2.mp3");
  celebracion = new SoundFile(this, "celebracion.mp3");
  musicaFondo = new SoundFile(this, "musica.mp3");

  // Fuente
  fuentePersonalizada = createFont("BaksoSapi.otf", 25);
  textFont(fuentePersonalizada);
}

void draw() {
  background(30);

  switch (escena) {
  case 1:
    mostrarSalaNavidad();
    break;
  case 2:
    mostrarMesaYMusica();
    break;
  case 3:
    mostrarEscenaUvas();
    break;
  case 4:
    mostrarBalcon();
    break;
  case 5:
    mostrarAbrazos();
    break;
  default:
    mostrarInicio();
    break;
  }

  if (fuegosActivos) {
    for (FuegoArtificial f : fuegos) {
      f.actualizar();
      f.mostrar();
    }
  }
}

// EVENTOS

void mousePressed() {
  if (escena == 2 && musicaFondo.isPlaying()) musicaFondo.stop();
  if (escena == 4 && polvora.isPlaying()) polvora.stop();
  if (escena == 5 && celebracion.isPlaying()) celebracion.stop();

  fuegosActivos = false;
  fuegos.clear();

  escena++;
  if (escena > 6) {
    escena = 0;
    campanadas.reiniciar();
    musicaReproducida = false;
  }
}

void keyPressed() {
  if (escena == 3 && key == ' ') campanadas.sumar();
  if (escena == 4 && keyCode == ENTER) {
    fuegosActivos = true;
    for (int i = 0; i < 5; i++) {
      fuegos.add(new FuegoArtificial(random(50, width - 50), random(30, 150)));
    }
    polvora.play();
  }
  if (escena == 5 && keyCode == UP && !celebracion.isPlaying()) {
    celebracion.play();
  }
  if (keyCode == LEFT) {
    escena--;
    if (escena < 0) escena = 0;
    if (escena < 2 && musicaFondo.isPlaying()) musicaFondo.stop();
    if (escena < 3 && campana.isPlaying()) campana.stop();
    if (escena < 4 && polvora.isPlaying()) polvora.stop();
    if (escena < 5 && celebracion.isPlaying()) celebracion.stop();
    fuegosActivos = false;
    fuegos.clear();
  }
}

// ESCENAS

void mostrarInicio() {
  image(inicio, 0, 0, width, height);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(25);
  text("Haga clic para comenzar", 430, 280);
}

void mostrarSalaNavidad() {
  if (sala != null) image(sala, 0, 0, width, height);
}

void mostrarMesaYMusica() {
  if (mesa != null) image(mesa, 0, 0, width, height);
  if (!musicaReproducida && musicaFondo != null) {
    musicaFondo.play();
    musicaReproducida = true;
  }
}

void mostrarEscenaUvas() {
  if (uvas != null) image(uvas, 0, 0, width, height);
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("Presione Espacio", width / 2, height - 60);
  campanadas.mostrarContador();
  if (campanadas.estaCompleto()) {
    campanadas.mostrarMensajeFinal();
  }
}

void mostrarBalcon() {
  if (balcon != null) image(balcon, 0, 0, width, height);
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("Presione Enter", 100, 580);
}

void mostrarAbrazos() {
  if (abrazos != null) image(abrazos, 0, 0, width, height);
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("Presione flecha superior", 630, 580);
}

// CLASES

class Campanadas {
  int contador;
  int maximo = 12;

  Campanadas() {
    contador = 0;
  }

  void sumar() {
    if (contador < maximo) {
      contador++;
      if (campana != null) campana.play();
    }
  }

  boolean estaCompleto() {
    return contador == maximo;
  }

  void reiniciar() {
    contador = 0;
  }

  void mostrarContador() {
    fill(255);
    textSize(18);
    textAlign(CENTER);
    text("Campanadas: " + contador + " / 12", width / 2, height - 30);
  }

  void mostrarMensajeFinal() {
    fill(0, 0, 0, 100);
    textSize(50);
    text("Feliz Año Nuevo!", 552, 72);
    fill(255, 180, 60);
    text("Feliz Año Nuevo!", 550, 70);
  }
}

class FuegoArtificial {
  ArrayList<Particula> particulas;
  boolean activo = true;

  FuegoArtificial(float x, float y) {
    particulas = new ArrayList<Particula>();
    for (int i = 0; i < 50; i++) {
      particulas.add(new Particula(x, y));
    }
  }

  void actualizar() {
    for (Particula p : particulas) p.actualizar();
    particulas.removeIf(p -> p.vida <= 0);
    if (particulas.isEmpty()) activo = false;
  }

  void mostrar() {
    for (Particula p : particulas) p.mostrar();
  }

  boolean estaActivo() {
    return activo;
  }
}

class Particula {
  float x, y, vx, vy, vida;
  color c;

  Particula(float x, float y) {
    this.x = x;
    this.y = y;
    float angle = random(TWO_PI);
    float speed = random(1, 5);
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
    vida = 255;
    c = color(int(random(256)), int(random(256)), int(random(256)));
  }

  void actualizar() {
    x += vx;
    y += vy;
    vy += 0.05;
    vida -= 3;
  }

  void mostrar() {
    noStroke();
    fill(c, vida);
    ellipse(x, y, 5, 5);
  }
}
