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

  beforeEach(() => {
    mouse = new ComputerMouse(
      [
        new Button(new Shape(40, 20, 5, "black"), "left"),
        new Button(new Shape(40, 20, 5, "black"), "right"),
        new Button(new Shape(10, 5, 5, "black"), "side-first"),
        new Button(new Shape(10, 5, 5, "black"), "side-second"),
        new Button(new Shape(10, 5, 5, "black"), "side-third"),
        new Button(new Shape(5, 5, 2, "black"), "middle"),
      ],
      new ScrollWheel(new Shape(5, 5, 5, "black"), 10),
      new Shape(20, 10, 1, "black"),
      new Light("white", new Shape(5, 5, 5, "black"), 100, true),
      new Position(0, 0), // cursor position,
      10, // cursor speed,
      "wired", // connection type,
      "ready"
    );
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
    mouse.click("right");
    expect(mouse.status).toBe("button right clicked");
  });

  test("should click left button", () => {
    mouse.click("left");
    expect(mouse.status).toBe("button left clicked");
  });

  test("should click middle button", () => {
    mouse.click("middle");
    expect(mouse.status).toBe("button middle clicked");
    expect(mouse.mouseSpeed).toBe(20);
  });

  test("should click first side button", () => {
    mouse.click("side-first");
    expect(mouse.status).toBe("button side-first clicked");
  });

  test("should double click button", () => {
    mouse.doubleClick("right");
    expect(mouse.status).toBe("button right double clicked");
  });

  test("should press button", () => {
    mouse.press("left");
    expect(mouse.status).toBe("button left pressed");
  });

  test("should scroll", () => {
    mouse.scroll("up", 20);
    expect(mouse.status).toBe("scroll up 20px");
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
