import {
  ComputerMouse,
  Position,
  Button,
  Light,
  ScrollWheel,
  Shape,
} from "./computerMouse";

describe("ComputerMouse", () => {
  let mouse: ComputerMouse;

  enum Status {
    off = "off",
    ready = "ready",
    clicked = "clicked",
    pressed = "pressed",
    scrolling = "scrolling",
  }

  beforeEach(() => {
    mouse = new ComputerMouse();
    mouse.buttons = [
      new Button(new Shape(20, 5, 5, "black"), "left", ""),
      new Button(new Shape(20, 5, 5, "black"), "right", ""),
      new Button(new Shape(20, 5, 5, "black"), "middle", ""),
    ];
    mouse.scrollWheel = new ScrollWheel(new Shape(20, 5, 5, "black"), 10);
    mouse.shape = new Shape(20, 5, 5, "black");
    mouse.light = new Light("white", new Shape(20, 5, 5, "black"), 100, true);
    mouse.position = new Position(0, 0);
    mouse.mouseSpeed = 10;
    mouse.connectionType = "wired";
    mouse.status = Status.ready;
  });

  test("should ready", () => {
    expect(mouse.status).toBe("ready");
  });

  test("should off", () => {
    mouse.turnOff();
    expect(mouse.status).toBe("off");
  });

  test("should move to new position", () => {
    mouse.move(10, 5);
    expect(mouse.position).toEqual(new Position(10, 5));
  });

  test("should click right button", () => {
    let rightButton = mouse.buttons.find((button) => button.type === "right");
    mouse.click(rightButton!);

    expect(mouse.status).toBe(Status.clicked);
    expect(rightButton?.state).toBe("clicked");
  });

  test("should click left button", () => {
    let leftButton = mouse.buttons.find((button) => button.type === "left");
    mouse.click(leftButton!);

    expect(mouse.status).toBe(Status.clicked);
    expect(leftButton?.state).toBe("clicked");
  });

  test("should click middle button", () => {
    let middleButton = mouse.buttons.find((button) => button.type === "middle");
    mouse.click(middleButton!);

    expect(mouse.status).toBe(Status.clicked);
    expect(middleButton?.state).toBe("clicked");
  });

  test("should double click button", () => {
    let rightButton = mouse.buttons.find((button) => button.type === "right");
    mouse.doubleClick(rightButton!);

    expect(mouse.status).toBe("doubleClicked");
    expect(rightButton?.state).toBe("doubleClicked");
  });

  test("should press button", () => {
    let rightButton = mouse.buttons.find((button) => button.type === "right");
    mouse.press(rightButton!);

    expect(mouse.status).toBe(Status.pressed);
    expect(rightButton?.state).toBe("pressed");
  });

  test("should scroll", () => {
    mouse.scroll("up", 20);

    expect(mouse.status).toBe(Status.scrolling);
    expect(mouse.scrollWheel.direction).toBe("up");
    expect(mouse.scrollWheel.scrollHeight).toBe(20);
  });

  test("should change mouse speed", () => {
    mouse.changeMouseSpeed(20);
    expect(mouse.mouseSpeed).toBe(20);
  });

  test("should change connection type", () => {
    mouse.changeConnectionType("wireless");
    expect(mouse.connectionType).toBe("wireless");
  });

  test("should turn light on and off", () => {
    mouse.turnOnLight();
    expect(mouse.light.status).toBe(true);
    mouse.turnOffLight();
    expect(mouse.light.status).toBe(false);
  });

  test("should change light color", () => {
    mouse.changeLightColor("red");
    expect(mouse.light.color).toBe("red");
  });

  test("should change light brightness", () => {
    mouse.adjustLightBrightness(50);
    expect(mouse.light.brightness).toBe(50);
  });
});
