<script setup lang="ts">
import ScrollQuiz from "@/components/ScrollQuiz.vue";
</script>

<template>
  <main>
      <scroll-quiz />
  </main>
</template>

<style scoped>

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  main {
    display: flex;
    justify-content: center;
    align-items: stretch;
    overflow-x: auto;
    gap: 20px;
    width: 100%;
  }

  header {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
