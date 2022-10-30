void convolution(PImage img, PImage img_modifiee, float[][] mask) {
  int i;
  int xx, yy;
  int yPos;
  img.loadPixels();
  img_modifiee.loadPixels();
  for (yy = mask.length; yy < heightCapture - mask.length; yy++) {
    yPos = yy * widthCapture; 
    for (xx = mask[0].length; xx < widthCapture - mask[0].length - 1; xx++) {
      i = xx + yPos;
      img_modifiee.pixels[i] = apply_mask(img, mask, yPos, xx);
    }
  }
  img_modifiee.updatePixels();
}


color apply_mask(PImage img, float[][] mask, int y, int x) {
  int Pos0 = x + y - mask[0].length - mask.length;
  int xx, yy;
  int yPos;
  int i;
  float r, g, b;

  float c = 0;

  for (yy = 0; yy < mask.length; yy++) {
    yPos = yy * widthCapture; 
    for (xx = 0; xx < mask[0].length; xx++) {
      i = xx + yPos + Pos0;
      // r g et b pas utiles si image noire et blanc
      r = red(img.pixels[i]);
      g = green(img.pixels[i]);
      b = blue(img.pixels[i]);
      c += mask[yy][xx] * (r + g + b);
    }
  }
  return color(c, c, c);
}


void seuillage(PImage img, PImage img_modifiee, float seuille) {
  for (int i = 0; i < img.pixels.length; i++) {
    if (red(img.pixels[i]) < seuille) {
      img_modifiee.pixels[i] = color(0, 0, 0);
    } else {
      img_modifiee.pixels[i] = color(255, 255, 255);
    }
  }
}

void gradient(PImage img, PImage img_modifiee) {
  double h, v;
  float c;
  PImage img_h = createImage(widthCapture, heightCapture, RGB);
  PImage img_v = createImage(widthCapture, heightCapture, RGB);

  convolution(img, img_h, contours_horizontal);
  convolution(img, img_v, contours_vertical);

  for (int i = 0; i < img.pixels.length; i++) {
    h = red(img_h.pixels[i]);
    v = red(img_v.pixels[i]);
    c = (float) Math.sqrt(h*h + v*v);
    img_modifiee.pixels[i] = color(c, c, c);
  }
}
