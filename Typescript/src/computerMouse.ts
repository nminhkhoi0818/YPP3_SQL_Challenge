class ComputerMouse {
  buttons: Button[];
  scrollWheel: ScrollWheel;
  shape: Shape;
  light: Light;
  position: Position;
  mouseSpeed: number;
  connectionType: String; // wired, wireless
  status: String; // off, ready, clicked, pressed, scrolling

  constructor(
    buttons: Button[],
    scrollWheel: ScrollWheel,
    shape: Shape,
    light: Light,
    position: Position,
    mouseSpeed: number,
    connectionType: String,
    status: String
  ) {
    this.buttons = buttons;
    this.scrollWheel = scrollWheel;
    this.shape = shape;
    this.light = light;
    this.position = position;
    this.mouseSpeed = mouseSpeed;
    this.connectionType = connectionType;
    this.status = status;
  }

  move(xOffset: number, yOffset: number): Position {
    this.position.x = this.position.x + xOffset;
    this.position.y = this.position.y + yOffset;
    return this.position;
  }

  click(type: String): String {
    this.status = "button " + type + " clicked";
    switch (type) {
      case "left":
        this.openTargetObject();
        break;
      case "right":
        this.openContextMenu();
        break;
      case "middle":
        this.changeMouseSpeed(20);
        break;
      case "side-first":
        this.goToNextPage();
        break;
      case "side-second":
        this.goToPreviousPage();
        break;
      case "side-third":
        this.changeConnectionType("wireless");
        break;
    }

    return this.status;
  }

  doubleClick(type: String): String {
    this.status = "button " + type + " double clicked";
    this.buttons.forEach((button) => {
      if (button.type === type) {
        button.doubleClick();
      }
    });

    return this.status;
  }

  press(type: String): String {
    this.status = "button " + type + " pressed";
    this.buttons.forEach((button) => {
      if (button.type === type) {
        button.press();
      }
    });

    return this.status;
  }

  scroll(direction: String, scrollHeight: number = 10): String {
    this.status = "scroll " + direction + " " + scrollHeight + "px";
    if (direction === "up") {
      this.scrollWheel.scrollUp();
    } else {
      this.scrollWheel.scrollDown();
    }

    return this.status;
  }

  changeMouseSpeed(speed: number) {
    this.mouseSpeed = speed;
  }

  changeConnectionType(type: String) {
    this.connectionType = type;
  }

  turnOff() {
    this.status = "off";
  }

  turnOffLight() {
    this.light.turnOff();
  }

  turnOnLight() {
    this.light.turnOn();
  }

  changeLightColor(color: String) {
    this.light.changeColor(color);
  }

  adjustLightBrightness(brightness: number) {
    this.light.adjustBrightness(brightness);
  }

  openTargetObject() {
    console.log("Open target object");
  }

  openContextMenu() {
    console.log("Open context menu");
  }

  goToNextPage() {
    console.log("Go to next page");
  }

  goToPreviousPage() {
    console.log("Go to previous page");
  }
}

class Position {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

class Button {
  shape: Shape;
  type: String;

  constructor(shape: Shape, type: String) {
    this.shape = shape;
    this.type = type;
  }

  click() {
    console.log(`Button ${this.type} clicked`);
  }

  doubleClick() {
    console.log(`Button ${this.type} double clicked`);
  }

  press() {
    console.log(`Button ${this.type} pressed`);
  }
}

class Light {
  color: String;
  shape: Shape;
  brightness: number;
  status: Boolean;

  constructor(
    color: String,
    shape: Shape,
    brightness: number,
    status: Boolean
  ) {
    this.color = color;
    this.shape = shape;
    this.brightness = brightness;
    this.status = status;
  }

  turnOn() {
    this.status = true;
  }

  turnOff() {
    this.status = false;
  }

  changeColor(color: String) {
    this.color = color;
  }

  adjustBrightness(brightness: number) {
    this.brightness = brightness;
  }
}

class ScrollWheel {
  shape: Shape;
  scrollSpeed: number;

  constructor(shape: Shape, scrollSpeed: number) {
    this.shape = shape;
    this.scrollSpeed = scrollSpeed;
  }

  scrollDown() {
    console.log("Scrolling down");
  }

  scrollUp() {
    console.log("Scrolling up");
  }

  press() {
    console.log("Scroll wheel pressed");
  }
}

class Shape {
  length: number;
  width: number;
  height: number;
  color: String;

  constructor(length: number, width: number, height: number, color: String) {
    this.length = length;
    this.width = width;
    this.height = height;
    this.color = color;
  }
}

export { ComputerMouse, Position, Button, Light, ScrollWheel, Shape };
