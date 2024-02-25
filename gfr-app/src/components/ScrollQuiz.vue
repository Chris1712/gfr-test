<script setup lang="ts">
import ScrollDetail from "@/components/ScrollDetail.vue";
import ScrollUtils, { type Scroll, type ScrollType } from "@/services/ScrollUtils";

let no_scrolls: number = 4;
let indexes: number[] = [];

// Pick random indexes from the scrolls array, ensuring no duplicates
while (indexes.length < no_scrolls) {
  let n = Math.floor(Math.random() * ScrollUtils.getScrolls().length);
  if (!indexes.includes(n)) {
    indexes.push(n);
  }
}

// Pick a random number from 1-4 to be the correct answer
const correctIndex: number = Math.floor(Math.random() * no_scrolls) ;
const correctScroll: Scroll = ScrollUtils.getScrolls()[indexes[correctIndex]];


</script>

<template>
  <div class="scoll-picker">
    <div class="scroll-detail" v-for="i in indexes" :key="i" >
      <scroll-detail :index="i" />
    </div>
  </div>
</template>

<style scoped>


.scoll-picker {
  display: flex;
  justify-content: center;
  align-items: stretch;
  overflow-x: auto;
  gap: 20px;
  width: 100%;
}


.scroll-detail {
  flex-basis: 100%;
  padding: 10px;
  border: 1px solid var(--color-text);
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }
}
</style>
