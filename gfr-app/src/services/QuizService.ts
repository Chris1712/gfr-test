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
            choices: quiz[n].choices.map(c => ScrollUtils.getScrollIndexByName(c)),
            answer: ScrollUtils.getScrollIndexByName(quiz[n].answer)
        }
    }
}
