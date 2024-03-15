import quiz from "@/assets/quiz.json";
import ScrollUtils from "@/services/ScrollUtils";


/**
 * Structure as useful for the app
 */
export interface Question {
    /**
     * Indexes of the choices, there are 4 of these
     */
    choices: number[]
    /**
     * Index of the answer
     */
    answer: number
}

export default {
    getQuestionCount(): number {
        return quiz.length
    },

    getQuestion(n: number): Question {
        return {
            choices: this.shuffle(quiz[n].choices.map(c => ScrollUtils.getScrollIndexByName(c))),
            answer: ScrollUtils.getScrollIndexByName(quiz[n].answer)
        }
    },

    shuffle(array: any[]) {
        const newArr = array.slice()
        for (let i = newArr.length - 1; i > 0; i--) {
            const rand = Math.floor(Math.random() * (i + 1));
            [newArr[i], newArr[rand]] = [newArr[rand], newArr[i]];
        }
        return newArr
    }
}
