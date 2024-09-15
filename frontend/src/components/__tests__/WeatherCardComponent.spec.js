import { test, expect } from "vitest";
import { mount } from "@vue/test-utils";
import WeatherCardComponent from "../WeatherCardComponent.vue";



test("mount component", async () => {
  expect(WeatherCardComponent).toBeTruthy();
  const props ={
    date: "Monday",
    temp: "10 °C",
    description: "clear sky",
    icon: "https://openweathermap.org/img/wn/10d@2x.png",
    }
  const wrapper = mount(WeatherCardComponent, {
    props:props
  });
  expect(wrapper.text()).toContain(props.date);
  expect(wrapper.text()).toContain(props.temp);
  expect(wrapper.text()).toContain(props.description);
  expect(wrapper.find("img").attributes("src")).toEqual(props.icon)
  

});