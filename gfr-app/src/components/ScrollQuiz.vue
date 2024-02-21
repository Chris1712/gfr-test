<script setup lang="ts">
import ScrollDetail from "@/components/ScrollDetail.vue";
import scrolls from "@/assets/scrolls.json";

const scrollName = "hi"

</script>

<template>
  <scroll-detail :name="scrolls[0].name" />
  <scroll-detail :name="scrolls[1].name" />
  <scroll-detail :name="scrolls[2].name" />
  <scroll-detail :name="scrolls[3].name" />
  <scroll-detail :name="scrolls[4].name" />
</template>

<style scoped>

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  main {
    display: flex; /* This makes it a flex container and aligns children in a row */
    justify-content: center; /* This aligns the children at the start of the container */
    align-items: center; /* This centers the children vertically */
    overflow-x: auto; /* Adds horizontal scrolling if the items overflow */
    gap: 10px; /* Optional: adds space between the children */
    width: 100%;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
