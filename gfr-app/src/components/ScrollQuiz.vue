<script setup lang="ts">
import {computed, ref} from 'vue';
import ScrollDetail from "@/components/ScrollDetail.vue";
import ScrollUtils, { type Scroll } from "@/services/ScrollUtils";

type mode = "guess" | "fadeoutWrong" | "fadeOutPicker" | "showCorrect" | "done";

// Number of scrolls to display
const no_scrolls: number = 4;

// Indexes of the scrolls to be displayed; no_scrolls of them
const indexes = ref<number[]>([]);
// Index of the correct scroll
const correctIndex = ref<number>();
// The correct scroll
const correctScroll = ref<Scroll>();

const currentMode = ref<mode>("guess");
const hidePicker = computed(() => ! (currentMode.value === "guess" || currentMode.value === "fadeoutWrong"));
const showAnswer = computed(() => currentMode.value === "showCorrect" || currentMode.value === "done");

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
  currentMode.value = "fadeoutWrong";
  console.log("Selected scroll: " + index);
  if (index === correctIndex.value) {
    console.log("Correct!");
  } else {
    console.log("Incorrect!");
  }

  setTimeout(() => {
    currentMode.value = "fadeOutPicker";
  }, 500);

  setTimeout(() => {
    currentMode.value = "showCorrect";
  }, 1000);

  setTimeout(() => {
    currentMode.value = "done";
  }, 1500);
}

function reset() {
  currentMode.value = "guess";
  pickScrolls();
}

</script>

<template>
  <h2>Scroll description:</h2>
  <p>{{correctScroll?.desc}}</p>
  <br>
  <div id="picker-container" v-if="!showAnswer">
    <h2 :class="{hide: hidePicker}">Select the matching scroll image:</h2><br>
    <div id="picker" class="scroll-group">
      <div class="scroll-item"
           :class="{
             'correct': i === correctIndex && currentMode !== 'guess',
             'hide': (i !== correctIndex && currentMode !== 'guess') || hidePicker
           }"
           v-for="i in indexes"
           :key="i"
           @click="selectScroll(i)">
        <scroll-detail :index="i" :hide-details="true"/>
      </div>
    </div>
  </div>
  <div id="answer-container" class="scroll-single show" v-if="showAnswer">
    <div>
      <scroll-detail :index="correctIndex" :hide-details="false"/>
    </div>
  </div>
  <br>
  <button :class="{'initiallyHidden': currentMode !== 'done', show: currentMode === 'done'}" @click="reset()">RESET</button>
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
}

.scroll-single {
  margin: 0 auto;
  max-width: 300px;
}

h2, p {
  text-align: center;
}

button {
  width: 100%;
  padding: 20px;
  border: 1px solid var(--color-text);
  background-color: var(--color-background);
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
  border: 1px solid var(--color-text);
  border-color: green !important;
}

.initiallyHidden {
  visibility: hidden;
}

.hide {
  animation: fadeOut 0.5s forwards;   /* forwards here means the final keyframe stays applied, IE they stay hidden */
}

@keyframes fadeOut {
  0% { opacity: 1; }
  100% { opacity: 0; }
}

.show {
  animation: fadeIn 0.5s forwards;   /* forwards here means the final keyframe stays applied, IE they stay hidden */
}

@keyframes fadeIn {
  0% { opacity: 0; }
  100% { opacity: 1; }
}

</style>
