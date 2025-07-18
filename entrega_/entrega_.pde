// Librería de sonido
import processing.sound.*;

// Variables de escena
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

  // Cargar fuente personalizada
  fuentePersonalizada = createFont("BaksoSapi.otf", 25); // asegúrate de que el nombre sea exacto
  textFont(fuentePersonalizada);
}

void draw() {
  background(30);

  // Mostrar la escena actual
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

  // Dibujar fuegos artificiales si están activos
  if (fuegosActivos) {
    for (FuegoArtificial f : fuegos) {
      f.actualizar();
      f.mostrar();
    }
  }
}

// Campanadas
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

    // Sombra
    fill(0, 0, 0, 100);
    textSize(50);
    text("Feliz Año Nuevo!", 550 + 2, 70 + 2);

    // Dorado cálido
    fill(255, 180, 60);
    textSize(50);
    text("Feliz Año Nuevo!", 550, 70);
  }
}

// Fuego Artificial
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
    for (Particula p : particulas) {
      p.actualizar();
    }
    particulas.removeIf(p -> p.vida <= 0);
    if (particulas.isEmpty()) {
      activo = false;
    }
  }

  void mostrar() {
    for (Particula p : particulas) {
      p.mostrar();
    }
  }

  boolean estaActivo() {
    return activo;
  }
}

class Particula {
  float x, y;
  float vx, vy;
  float vida;
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
    vy += 0.05; // gravedad leve
    vida -= 3;
  }

  void mostrar() {
    noStroke();
    fill(c, vida);
    ellipse(x, y, 5, 5);
  }
}

// ESCENAS

void mostrarInicio() {
  image(inicio, 0, 0, width, height); // solo si tienes una imagen cargada ante
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

void mostrarTextoAlterno(String txt) {
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(28);
  text(txt, width / 2, height / 2);
}

// EVENTOS

void mousePressed() {
  // Detener música navideña si salimos de escena 2
  if (escena == 2 && musicaFondo != null && musicaFondo.isPlaying()) {
    musicaFondo.stop();
    musicaReproducida = false;
  }

  // Detener pólvora si salimos de escena 4
  if (escena == 4) {
    fuegosActivos = false;
    fuegos.clear(); // elimina las esferas
    if (polvora != null) {
      polvora.stop();
    }
  }

  // Detener música de celebración si salimos de escena 5
  if (escena == 5 && celebracion != null && celebracion.isPlaying()) {
    celebracion.stop();
  }

  // Avanzar escena
  escena++;

  // Reinicio total
  if (escena > 6) {
    escena = 0;
    campanadas.reiniciar();
    fuegos.clear();
    fuegosActivos = false;
    musicaReproducida = false;
  }
}


void keyPressed() {
  if (escena == 3 && key == ' ') {
    campanadas.sumar();
  } else if (escena == 4 && keyCode == ENTER) {
    fuegosActivos = true;
    for (int i = 0; i < 5; i++) {
      float x = random(50, width - 50);
      float y = random(30, 150);
      fuegos.add(new FuegoArtificial(x, y));
    }
    if (polvora != null) polvora.play();
  } else if (escena == 5 && keyCode == UP) {
    if (celebracion != null && !celebracion.isPlaying()) {
      celebracion.play();
    }
  } else if (keyCode == LEFT) {
    escena--;

    // Evitar que la escena baje de 0
    if (escena < 0) {
      escena = 0;
    }

    // ⚠️ Detener música o sonidos si te devuelves desde escena 2, 3, 4 o 5
    if (escena < 2 && musicaFondo != null && musicaFondo.isPlaying()) {
      musicaFondo.stop();
      musicaReproducida = false;
    }
    if (escena < 3 && campana != null && campana.isPlaying()) {
      campana.stop();
    }
    if (escena < 4 && polvora != null && polvora.isPlaying()) {
      polvora.stop();
      fuegosActivos = false;
      fuegos.clear();
    }
    if (escena < 5 && celebracion != null && celebracion.isPlaying()) {
      celebracion.stop();
    }
  }
}
