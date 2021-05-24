import gzip
import numpy as np
import mlflow

from sklearn.naive_bayes import GaussianNB
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix

def read_gz(filename):
    file = gzip.open(filename)
    contents = file.read()
    return contents

if __name__ == "__main__":
    train_labels_bytes = read_gz('data/train-labels-idx1-ubyte.gz')
    train_images = read_gz('data/train-images-idx3-ubyte.gz')
    test_images = read_gz('data/t10k-images-idx3-ubyte.gz')
    test_labels_bytes = read_gz('data/t10k-labels-idx1-ubyte.gz')
    
    train_labels_int = [x for x in train_labels_bytes]
    train_labels = np.array(train_labels_int[8:])
    
    test_labels_int = [x for x in test_labels_bytes]
    test_labels = np.array(test_labels_int[8:])
    
    # 60000 imgs, 28x28 pixels -> matrix w 60000 rows and 28x28 cols
    img_count = int.from_bytes(train_images[4:8], "big")
    row_count = int.from_bytes(train_images[8:12], "big")
    col_count = int.from_bytes(train_images[12:16], "big")
    features = row_count * col_count

    # organize
    train_pixels1d = np.array([x for x in train_images[16:]])
    train_pixels = train_pixels1d.reshape(60000, 28*28)
    
    test_pixels1d = np.array([x for x in test_images[16:]])
    test_pixels = test_pixels1d.reshape(10000, 28*28)
    
    with mlflow.start_run():
        model = GaussianNB()
        model.fit(train_pixels, train_labels)

        predicted_digits = model.predict(test_pixels)
        accuracy = accuracy_score(test_labels, predicted_digits)

        print("Digit prediction accuracy: %f" % accuracy)

        mlflow.log_metric("accuracy_score", accuracy)
