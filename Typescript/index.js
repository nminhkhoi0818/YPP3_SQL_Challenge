"use strict";
class Bus {
    constructor(make, model, year) {
        this.make = make;
        this.model = model;
        this.year = year;
    }
}
const myBus = new Bus("Volvo", "9400", 2019);
console.log(myBus.make);
console.log(myBus.model);
console.log(myBus.year);
