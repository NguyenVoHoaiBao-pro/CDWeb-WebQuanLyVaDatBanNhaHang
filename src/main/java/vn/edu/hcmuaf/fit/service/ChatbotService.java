package vn.edu.hcmuaf.fit.service;

import vn.edu.hcmuaf.fit.dao.RecommendationDAO;
import vn.edu.hcmuaf.fit.model.Product;

import java.util.List;

public class ChatbotService {

    RecommendationDAO dao = new RecommendationDAO();

    public String reply(String message){

        List<Product> products =
                dao.findAllProducts();

        message = message.toLowerCase();

        Product bestProduct = null;

        int bestScore = 0;

        for(Product p : products){

            int score = 0;

            String keywords =
                    p.getAiKeywords();

            if(keywords == null){
                continue;
            }

            String[] arr =
                    keywords.toLowerCase().split(",");

            for(String key : arr){

                key = key.trim();

                if(message.contains(key)){

                    score++;
                }
            }

            if(score > bestScore){

                bestScore = score;

                bestProduct = p;
            }
        }

        // TÌM THẤY
        if(bestProduct != null){

            return
                    "🍽️ Tôi gợi ý cho bạn:<br><br>"

                            + "<b>"
                            + bestProduct.getName()
                            + "</b><br><br>"

                            + bestProduct.getAiDescription()
                            + "<br><br>"

                            + "<a href='product/"
                            + bestProduct.getId()
                            + "' class='btn btn-sm btn-warning'>"

                            + "Xem món"

                            + "</a>";
        }

        // KHÔNG TÌM THẤY
        return
                "Tôi chưa hiểu món bạn muốn 😅<br>"
                        + "Hãy thử mô tả như:<br><br>"

                        + "• món cay<br>"
                        + "• hải sản<br>"
                        + "• bò nướng<br>"
                        + "• món ngọt<br>"
                        + "• ít dầu mỡ";
    }
}