from transformers import AutoModelForSequenceClassification, AutoTokenizer
import torch
import torch.nn.functional as F

class ToxicityModel:
    def __init__(self):
        self.tokenizer = AutoTokenizer.from_pretrained("cardiffnlp/twitter-roberta-base-offensive")
        self.model = AutoModelForSequenceClassification.from_pretrained("cardiffnlp/twitter-roberta-base-offensive")

    def predict(self, text):
        inputs = self.tokenizer(text, return_tensors="pt")
        with torch.no_grad():
            outputs = self.model(**inputs)
            probs = F.softmax(outputs.logits, dim=1)
            score = probs[0][1].item()  # Offensive class
        return score
