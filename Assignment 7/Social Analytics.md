

```python
#Dependencies
import tweepy
import json
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import time
```


```python
#Import and Initialize Sentiment Analyzer
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
analyzer = SentimentIntensityAnalyzer()
```


```python
#Twitter API Keys
#from config import consumer_key, consumer_secret, access_token, access_token_secret
consumer_key = "c8iPOfqAcm1qys97q3RW0wKOM"
consumer_secret = "6sUoqS7FtJkIKTfdoWaZHEf5quOEeqAfrJLsSJMzJd2Aw1myoF"
access_token = "229598666-EnGXtgqnFXT8zjHrMTI7medln9PlPdT5thbQhjJh"
access_token_secret = "Bdr3ujJgJqgf6wksE2b8OQ7CxkFTCAi5KolqLZrc9giNH"
```


```python
#Setup Tweepy API Authentication
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth, parser=tweepy.parsers.JSONParser())

#Target Search Term of the various Media channels
Media_users = ("@BBC", "@CBS", "@CNN","@FoxNews", "@nytimes")

#Array to hold sentiment
Sentiment_array = []

#Extracting the first 100 tweets in each Media Channel

for user in Media_users:
    #Setting the tweet count as 100
    tweetcount=100
    #print("Start tweets from %s"%user)
    
    # Extracting 5 pages of tweets
    for x in range(5):
        public_tweets=api.user_timeline(user,page=x)
        #For each tweet 
        for tweet in public_tweets:
            #Calculating the compound,positive,negative and neutral value for each tweet
            compound = analyzer.polarity_scores(tweet["text"])["compound"]
            pos = analyzer.polarity_scores(tweet["text"])["pos"]
            neu = analyzer.polarity_scores(tweet["text"])["neu"]
            neg = analyzer.polarity_scores(tweet["text"])["neg"]
            # Store Tweet in Array
            Sentiment_array.append({"Media":user,
                                    "Tweet Text":tweet["text"],
                                    "Compound":compound,
                                    "Positive":pos,
                                    "Negative":neg,
                                    "Neutral":neu,
                                    "Date":tweet["created_at"],
                                    "Tweets Ago":tweetcount})
            #Decreasing tweet count by 1
            tweetcount-=1
```


```python
#Creating a dataframe from the Sentiment Array
Sentiment_DF=pd.DataFrame.from_dict(Sentiment_array)
#Removing the '@' from Media column in the data frame
Sentiment_DF['Media'] = Sentiment_DF['Media'].map(lambda x: x.lstrip('@'))

#Re_arranging the order of columns before saving into CSV file
Sentiment_DF=Sentiment_DF[["Media","Date","Tweet Text","Compound","Positive","Negative","Neutral","Tweets Ago"]]

#Storing into a CSV File
Sentiment_DF.to_csv("Media_SentimentAnalysis.csv")

Sentiment_DF.head(10)
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Media</th>
      <th>Date</th>
      <th>Tweet Text</th>
      <th>Compound</th>
      <th>Positive</th>
      <th>Negative</th>
      <th>Neutral</th>
      <th>Tweets Ago</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>BBC</td>
      <td>Wed Mar 07 19:12:02 +0000 2018</td>
      <td>'Harry was looking at his family for the first...</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.0</td>
      <td>1.000</td>
      <td>100</td>
    </tr>
    <tr>
      <th>1</th>
      <td>BBC</td>
      <td>Wed Mar 07 18:23:04 +0000 2018</td>
      <td>✂️ ‘My hair is a symbol of pride.’\n\n💇🏽💇🏿💇🏾 S...</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.0</td>
      <td>1.000</td>
      <td>99</td>
    </tr>
    <tr>
      <th>2</th>
      <td>BBC</td>
      <td>Wed Mar 07 17:42:01 +0000 2018</td>
      <td>The little mouse that inspired Pikachu is actu...</td>
      <td>0.4987</td>
      <td>0.264</td>
      <td>0.0</td>
      <td>0.736</td>
      <td>98</td>
    </tr>
    <tr>
      <th>3</th>
      <td>BBC</td>
      <td>Wed Mar 07 17:27:29 +0000 2018</td>
      <td>RT @BBCTwo: If you haven't seen #ACSVersace ye...</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.0</td>
      <td>1.000</td>
      <td>97</td>
    </tr>
    <tr>
      <th>4</th>
      <td>BBC</td>
      <td>Wed Mar 07 17:22:51 +0000 2018</td>
      <td>RT @BBCBreakfast: In many ways Hedy Lamarr was...</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.0</td>
      <td>1.000</td>
      <td>96</td>
    </tr>
    <tr>
      <th>5</th>
      <td>BBC</td>
      <td>Wed Mar 07 17:22:23 +0000 2018</td>
      <td>RT @BBCScotlandNews: A Scottish school has won...</td>
      <td>0.8555</td>
      <td>0.370</td>
      <td>0.0</td>
      <td>0.630</td>
      <td>95</td>
    </tr>
    <tr>
      <th>6</th>
      <td>BBC</td>
      <td>Wed Mar 07 17:16:45 +0000 2018</td>
      <td>RT @bbceurovision: A storm is coming.@surieoff...</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.0</td>
      <td>1.000</td>
      <td>94</td>
    </tr>
    <tr>
      <th>7</th>
      <td>BBC</td>
      <td>Wed Mar 07 17:14:49 +0000 2018</td>
      <td>RT @BBCTwo: Nostalgia heaven! How many of thes...</td>
      <td>0.5562</td>
      <td>0.183</td>
      <td>0.0</td>
      <td>0.817</td>
      <td>93</td>
    </tr>
    <tr>
      <th>8</th>
      <td>BBC</td>
      <td>Wed Mar 07 17:13:49 +0000 2018</td>
      <td>📖 Time to 'embiggen' your vocabulary.\n\nA new...</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.0</td>
      <td>1.000</td>
      <td>92</td>
    </tr>
    <tr>
      <th>9</th>
      <td>BBC</td>
      <td>Wed Mar 07 16:15:06 +0000 2018</td>
      <td>RT @bbccomedy: WOOF! ❤️#RikMayallDay https://t...</td>
      <td>0.0000</td>
      <td>0.000</td>
      <td>0.0</td>
      <td>1.000</td>
      <td>91</td>
    </tr>
  </tbody>
</table>
</div>




```python
#Creating an array with the unique Media sources in the data frame
Media_Source=Sentiment_DF["Media"].unique()

#Plotting the graph for each media source
for media in Media_Source:
    # Creating a temporary data frame to store for only one media channel at a time
    Temp_DF=Sentiment_DF[Sentiment_DF["Media"]==media]
    plt.scatter(Temp_DF["Tweets Ago"],Temp_DF["Compound"], marker="o", linewidth=0, alpha=0.8, label=media,
                facecolors=Temp_DF.Media.map({"BBC": "blue", "CBS" : "purple",  "CNN": 'red',
                                              "FoxNews":"green","nytimes":"yellow"}))


#plt.hlines(0,0,np.arange(len(Sentiment_DF["Compound"])),alpha=1)
#Setting the legend 
plt.legend(bbox_to_anchor = (1,1),title="Media Sources")
#Setting the title,x_axis and y_axis labels
plt.title("Sentiment Analysis of Media Tweets (%s)" % (time.strftime("%x")), fontsize=14)
plt.xlabel("Tweets Ago")
plt.ylabel("Tweet Polarity")
#Setting the x_axis and y_axis limits
plt.xlim(101,0)
plt.ylim(-1,1)
#Setting the grid
plt.grid(True)

#Saving the figue
plt.savefig("Sentiment Analysis of Media Tweets.png", bbox_inches='tight')

plt.show()
```


![png](output_5_0.png)



```python
#Calculating the mean for each Media channel and storing to a dataframe
Media_Compound_Means=Sentiment_DF.groupby("Media").mean()["Compound"].to_frame()
#Resetting the index 
Media_Compound_Means.reset_index(inplace=True)

Media_Compound_Means
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Media</th>
      <th>Compound</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>BBC</td>
      <td>0.190192</td>
    </tr>
    <tr>
      <th>1</th>
      <td>CBS</td>
      <td>0.300487</td>
    </tr>
    <tr>
      <th>2</th>
      <td>CNN</td>
      <td>-0.043570</td>
    </tr>
    <tr>
      <th>3</th>
      <td>FoxNews</td>
      <td>-0.031852</td>
    </tr>
    <tr>
      <th>4</th>
      <td>nytimes</td>
      <td>-0.009911</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Setting the x_axis and y-axis value
x_axis=Media_Compound_Means.index.values
y_axis=Media_Compound_Means["Compound"]

# Intializing the plots
fig,ax=plt.subplots()

#Setting the plot and assigning the color 
bars=ax.bar(x_axis,y_axis,align="edge",width=1,linewidth=1,
            edgecolor='black',color=["green","purple","red","blue","yellow"])
```


```python
#Setting the ticks for the bar graph
tick_locations = [value+0.5 for value in range(len(x_axis))]
plt.xticks(tick_locations,["BBC","CBS","CNN","Fox","NYT"])

#Setting the text label in the bar graph
#If value is positive then put True in the Summary else place False, for changing the color based on the value
Media_Compound_Means["Positive"]=Media_Compound_Means["Compound"]>0
#Assign the height based on whether it is a  positive value
height = Media_Compound_Means.Positive.map({True: 0.03 , False: -0.03})
#Setting the value label on the each bar
for bar in bars:
    ax.text(bar.get_x() + bar.get_width()/2, bar.get_height()+height[bars.index(bar)],
            round(Media_Compound_Means["Compound"][bars.index(bar)],3),ha='center', va='bottom')


#Setting the x_axis limits
ax.set_xlim(0, len(x_axis))
#Setting the y_axis limits dynamically by finding the maximum and minimum value in y-axis
ax.set_ylim(min(y_axis)-0.1, max(y_axis)+0.1)

#Setting a horizontal line at y=0
plt.hlines(0,0,len(x_axis))

#Setting the title of the graph
ax.set_title("Overall Media Sentiment based on Twitter (%s)" % (time.strftime("%x")), fontsize=14)
#Setting the y_axis label
ax.set_ylabel("Twitter Polarity")

#Saving the graph
plt.savefig("Overall_Media_Sentiment_based_on_Twitter.png", bbox_inches='tight')
plt.show()
```


![png](output_8_0.png)

