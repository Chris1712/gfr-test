<script setup lang="ts">
import { ref } from 'vue';
import ScrollDetail from "@/components/ScrollDetail.vue";
import ScrollImage from "@/components/ScrollImage.vue";
import ScrollUtils, { type Scroll } from "@/services/ScrollUtils";

let no_scrolls: number = 4;
let indexes: number[] = [];
const guessedScrollIndex = ref(-1); // -1 when not guessed, then changes to guessed index

// Pick random indexes from the scrolls array, ensuring no duplicates
while (indexes.length < no_scrolls) {
  let n = Math.floor(Math.random() * ScrollUtils.getScrolls().length);
  if (!indexes.includes(n)) {
    indexes.push(n);
  }
}

// Pick a random scroll to be the correct answer
const correctIndex: number =  indexes[Math.floor(Math.random() * no_scrolls)];
const correctScroll: Scroll = ScrollUtils.getScrolls()[correctIndex];


function selectScroll(index: number) {
  console.log("Selected scroll: " + index);
  guessedScrollIndex.value = index;
  if (index === correctIndex) {
    console.log("Correct!");
  } else {
    console.log("Incorrect!");
  }
}

</script>

<template>
  <h2>Scroll description:</h2>
  <p>{{correctScroll.desc}}</p>
  <br>
  <h2>Pick the right scroll image:</h2><br>
  <div id="picker" class="scroll-group" v-if="guessedScrollIndex<0">
    <div class="scroll-detail" v-for="i in indexes" :key="i" @click="selectScroll(i)">
      <scroll-image :index="i" />
    </div>
  </div>
  <div id="answers" class="scroll-group" v-if="guessedScrollIndex>=0">
    <div class="scroll-detail" v-for="i in indexes" :key="i"
         :class="{'correct': i === correctIndex, 'incorrect': i !== correctIndex && i === guessedScrollIndex}">
      <scroll-detail :index="i" />
    </div>
  </div>
</template>

<style scoped>


.scroll-group {
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

.correct {
  border-color: green !important;
}

.incorrect {
  border-color: red !important;
}

</style>
