package vn.edu.hcmuaf.fit.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Bài xác thực danh tính
 */
public final class IdentityQuiz {

    public static final class Question {
        private final String id;
        private final String text;
        private final List<String> options;
        private final int correctIndex;

        public Question(String id, String text, List<String> options, int correctIndex) {
            this.id = id;
            this.text = text;
            this.options = options;
            this.correctIndex = correctIndex;
        }

        public String getId() {
            return id;
        }

        public String getText() {
            return text;
        }

        public List<String> getOptions() {
            return options;
        }

        public int getCorrectIndex() {
            return correctIndex;
        }
    }

    private static final List<Question> QUESTIONS = Collections.unmodifiableList(Arrays.asList(
            new Question(
                    "q1",
                    "Tên nhà hàng của chúng ta là gì?",
                    Arrays.asList("Nhà Hàng Của Chúng Ta", "Pizza Hut", "Highlands Coffee"),
                    0
            ),
            new Question(
                    "q2",
                    "Giờ mở cửa của nhà hàng?",
                    Arrays.asList("08:00 – 22:00", "06:00 – 18:00", "24/24"),
                    0
            ),
            new Question(
                    "q3",
                    "Mỗi khung giờ trên lịch đặt bàn kéo dài bao lâu?",
                    Arrays.asList("2 giờ", "1 giờ", "30 phút"),
                    0
            ),
            new Question(
                    "q4",
                    "Khách được chọn tối đa bao nhiêu khung giờ liên tiếp?",
                    Arrays.asList("3 khung (6 giờ)", "5 khung", "1 khung"),
                    0
            ),
            new Question(
                    "q5",
                    "Sau khi khách rời bàn, hệ thống tự thêm bao nhiêu khung để dọn bàn?",
                    Arrays.asList("1 khung (2 giờ)", "Không có khung dọn", "3 khung"),
                    0
            )
    ));

    private IdentityQuiz() {
    }

    public static List<Question> getQuestions() {
        return QUESTIONS;
    }

    public static boolean grade(Map<String, String> answers) {
        if (answers == null || answers.isEmpty()) {
            return false;
        }
        int correct = 0;
        for (Question q : QUESTIONS) {
            String submitted = answers.get(q.getId());
            if (submitted == null) {
                continue;
            }
            try {
                int idx = Integer.parseInt(submitted.trim());
                if (idx == q.getCorrectIndex()) {
                    correct++;
                }
            } catch (NumberFormatException ignored) {
            }
        }
        return correct == QUESTIONS.size();
    }

    public static Map<String, String> answersFromRequest(Map<String, String[]> paramMap) {
        Map<String, String> out = new LinkedHashMap<>();
        for (Question q : QUESTIONS) {
            String[] vals = paramMap.get(q.getId());
            if (vals != null && vals.length > 0) {
                out.put(q.getId(), vals[0]);
            }
        }
        return out;
    }
}
