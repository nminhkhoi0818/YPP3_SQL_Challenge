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
    off,
    ready,
    clicked,
    doubleClicked,
    pressed,
    scrolling,
  }

  beforeEach(() => {
    mouse = new ComputerMouse();
    mouse.buttons = [
      new Button(new Shape(20, 5, 5, "black"), "left", Status.ready),
      new Button(new Shape(20, 5, 5, "black"), "right", Status.ready),
      new Button(new Shape(20, 5, 5, "black"), "middle", Status.ready),
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
    expect(mouse.status).toBe(Status.ready);
  });

  test("should off", () => {
    mouse.turnOff();
    expect(mouse.status).toBe(Status.off);
  });

  test("should move to new position", () => {
    mouse.move(10, 5);
    expect(mouse.position).toEqual(new Position(10, 5));
  });

  test("should click right button", () => {
    mouse.click("right");

    let rightButton = mouse.buttons.find((button) => button.type === "right");
    expect(rightButton?.state).toBe(Status.clicked);
  });

  test("should click left button", () => {
    mouse.click("left");

    let leftButton = mouse.buttons.find((button) => button.type === "left");
    expect(leftButton?.state).toBe(Status.clicked);
  });

  test("should click middle button", () => {
    mouse.click("middle");

    let middleButton = mouse.buttons.find((button) => button.type === "middle");
    expect(middleButton?.state).toBe(Status.clicked);
  });

  test("should double click button", () => {
    mouse.doubleClick("right");

    let rightButton = mouse.buttons.find((button) => button.type === "right");
    expect(rightButton?.state).toBe(Status.doubleClicked);
  });

  test("should press button", () => {
    mouse.press("right");

    let rightButton = mouse.buttons.find((button) => button.type === "right");
    expect(rightButton?.state).toBe(Status.pressed);
  });

  test("should scroll", () => {
    mouse.scroll("up", 20, 10);
    expect(mouse.scrollWheel.direction).toBe("up");
    expect(mouse.scrollWheel.scrollSpeed).toBe(20);
    expect(mouse.scrollWheel.scrollTime).toBe(10);
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
