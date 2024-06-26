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
        new Button(new Shape(5, 5, 5, "black"), "left"),
        new Button(new Shape(5, 5, 5, "black"), "right"),
        new Button(new Shape(5, 5, 5, "black"), "middle"),
      ],
      new ScrollWheel(new Shape(5, 5, 5, "black"), 10),
      new Shape(20, 10, 1, "black"),
      new Light("white", new Shape(5, 5, 5, "black"), 100, true),
      new Position(0, 0)
    );
  });

  test("should click button", () => {
    expect(mouse.click("right")).toBe(
      "right button clicked at position (0, 0)"
    );
  });

  test("should move to new position", () => {
    mouse.move(10, 5);
    expect(mouse.position).toEqual(new Position(10, 5));
  });

  test("should press button", () => {
    mouse.move(-5, 10);
    expect(mouse.press("left")).toBe(
      "left button pressed at position (-5, 10)"
    );
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
});
