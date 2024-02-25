<script setup lang="ts">
import { ref } from 'vue';
import ScrollDetail from "@/components/ScrollDetail.vue";
import ScrollImage from "@/components/ScrollImage.vue";
import ScrollUtils, { type Scroll } from "@/services/ScrollUtils";

// Number of scrolls to display
const no_scrolls: number = 4;

// Indexes of the scrolls to be displayed; no_scrolls of them
const indexes = ref<number[]>([]);
// Index of the correct scroll
const correctIndex = ref<number>();
// The correct scroll
const correctScroll = ref<Scroll>();
//  Index of the scroll guessed by the user; -1 when not guessed, then changes to guessed index
const guessedScrollIndex = ref<number>(-1);

pickScrolls();

// Pick no_scrolls randomly, and then select one of those as the correct one
function pickScrolls() {
  indexes.value = []; // Reset the list of scrolls

  while (indexes.value.length < no_scrolls) {
    let n = Math.floor(Math.random() * ScrollUtils.getScrolls().length);
    if (!indexes.value.includes(n)) {
      indexes.value.push(n);
    }
  }

  correctIndex.value =  indexes.value[Math.floor(Math.random() * no_scrolls)];
  correctScroll.value = ScrollUtils.getScrolls()[correctIndex.value];
}


function selectScroll(index: number) {
  console.log("Selected scroll: " + index);
  guessedScrollIndex.value = index;
  if (index === correctIndex.value) {
    console.log("Correct!");
  } else {
    console.log("Incorrect!");
  }
}

function reset() {
  guessedScrollIndex.value = -1;
  pickScrolls();
}

</script>

<template>
  <h2>Scroll description:</h2>
  <p>{{correctScroll.desc}}</p>
  <br>
  <h2>Pick the right scroll image:</h2><br>
  <div id="picker" class="scroll-group" v-if="guessedScrollIndex < 0">
    <div class="scroll-item" v-for="i in indexes" :key="i" @click="selectScroll(i)">
      <scroll-image :index="i" />
    </div>
  </div>
  <div id="answers" class="scroll-group" v-if="guessedScrollIndex >= 0">
    <div class="scroll-item" v-for="i in indexes" :key="i"
         :class="{'correct': i === correctIndex, 'incorrect': i !== correctIndex && i === guessedScrollIndex}">
      <scroll-detail :index="i" />
    </div>
  </div>
  <br>
  <button v-if="guessedScrollIndex >=0 " @click="reset()">RESET</button>
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

.scroll-item {
  flex-basis: 100%;
  padding: 10px;
  border: 1px solid var(--color-text);
}

button {
  width: 100%;
  padding: 20px;
  border: 1px solid var(--color-text);
  background-color: var(--color-bg);
  color: var(--color-text);
  cursor: pointer;
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
