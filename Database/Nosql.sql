db.automotive.aggregate({$group:{_id:{proID:"$asin", count1:{$sum:1},rate:"$overall"},count:{$sum:1}}},{ "$project": { 
            "count":-1, 
            "percentage": { 
                "$concat": [ { "$substr": [ { "$multiply": [ { "$divide": [ "$count", {"$literal": nums }] }, 100 ] }, 0,2 ] }, "", "%" ]}
            }
        },{$limit:50})
		
		

		
		
		
db.automotive.aggregate({$group:{_id:{rate:"$overall",proID:"$asin"},count:{$sum:1}}},{$project:{"rate":-1}},{$limit:50})
db.automotive.aggregate({$group:{_id:{rate:"$overall",proID:"$asin"},count:{$sum:1}}},{$project:{count:1}},{$limit:50})
db.automotive.aggregate({$group:{_id:{rate:"$overall",proID:"$asin"},count:{$sum:1}}},{$project:{count:1}},{$limit:50})

db.automotive.aggregate({$group:{_id:{rate:"$overall",proID:"$asin"},count:{$sum:1}}}, { $group : {_id:'$count', count:{$sum:1}}},{ $sort  : {_id: 1}}])

db.automotive.aggregate({ $group:{_id:"$asin",         
        5: { $sum: { $cond :  [{ $eq : ["$overall", 5]}, 1, 0]} },
		4: { $sum: { $cond :  [{ $eq : ["$overall", 4]}, 1, 0]} },
        3: { $sum: { $cond : [{ $eq : ["$overall", 3]}, 1, 0]} },
        2: { $sum: { $cond :  [{ $eq : ["$overall", 2]}, 1, 0]} },
		1: { $sum: { $cond :  [{ $eq : ["$overall", 1]}, 1, 0]} },
        Total: { $sum: 1 }
    } }, 
    {$project:{5:1, 4:1, 3:1,  2:1, 1:1, Total:1, 
	5: { $divide: [ "$5", "$Total" ]},
	4: { $divide: [ "$4", "$Total" ]},
	3: { $divide: [ "$3", "$Total" ]},
	2: { $divide: [ "$2", "$Total" ]},
	1: { $divide: [ "$1", "$Total" ]}}})
	
	db.automotive.aggregate({$group:{_id:"$asin",         
        5: { $sum: { $cond :  [{ $eq : ["$overall", 5]}, 1, 0]} },
		4: { $sum: { $cond :  [{ $eq : ["$overall", 4]}, 1, 0]} },
        3: { $sum: { $cond : [{ $eq : ["$overall", 3]}, 1, 0]} },
        2: { $sum: { $cond :  [{ $eq : ["$overall", 2]}, 1, 0]} },
		1: { $sum: { $cond :  [{ $eq : ["$overall", 1]}, 1, 0]} },
        Total: { $sum: 1 }
    } })
	
db.automotive.aggregate({ $group:{_id:"$asin",         
        5: { $sum: { $cond :  [{ $eq : ["$overall", 5]}, 1, 0]} },
		4: { $sum: { $cond :  [{ $eq : ["$overall", 4]}, 1, 0]} },
        3: { $sum: { $cond : [{ $eq : ["$overall", 3]}, 1, 0]} },
        2: { $sum: { $cond :  [{ $eq : ["$overall", 2]}, 1, 0]} },
		1: { $sum: { $cond :  [{ $eq : ["$overall", 1]}, 1, 0]} },
        Total: { $sum: 1 }
    } }, 
    {$project:{
	5: { $divide: [ "$5", "$Total" ]},
	4: { $divide: [ "$4", "$Total" ]},
	3: { $divide: [ "$3", "$Total" ]},
	2: { $divide: [ "$2", "$Total" ]},
	1: { $divide: [ "$1", "$Total" ]}}},{$limit:50})
	
	
	
db.automotive.aggregate(
   [
     { $sort: { reviewerID: 1, reviewTime: 1 } },
     {
       $group:
         {
           _id: "$reviewerID",
           firstreviewTime: { $first: "$reviewTime" }
         }
     }
   ]
)

db.automotive.aggregate(
   [
     { $sort: { asin: 1, reviewTime: 1 } },
     {
       $group:
         {
           _id: "$asin",
           lastreviewTime: { $last: "$reviewTime" }
         }
     }
   ]
)	

db.articles.aggregate([{
  "$unwind": "$article.category"
}, {
  "$group": {
    "_id":  {
      title: "$article.category.title",
      year: { $year: "$published" },
      day: { $dayOfYear: "$published" }
    },
    "count": { "$sum" : 1 }
  }
}, {
  $group: {
    _id: {
      year: "$_id.year",
      day: "$_id.day"
    },
    categories: {
      $push: { title: "$_id.title", count: "$count" }
    }
  }
}]).map( function (data) {
  // Using map here is the best way I could think to limit
  // the array size. Perhaps someone can do it all together
  // But this should do the trick.
  data.categories.sort( function (a, b) {
    return b.count - a.count;
  });
  data.categories = data.categories.slice(0, 5);
  return data;
});

db.automotive.aggregate(
   [
     { $sort: { asin: 1, reviewTime: 1 } },
     {
       $group:
         {
           _id: "$asin",
           topitems: {
      $push: { proID: "$_id.asin", date: "$reviewTime" }
    }
         }
     },{$limit:50}
   ]
).map( function (data) {
  data.topitems = data.topitems.slice(0, 10);
  return data;
})	

db.automotive.createIndex({"reviewText":"text"})
db.automotive.aggregate(
   [
     { $match: { $text: { $search: "highly recommend" } } },
     {
       $group:
         {
           _id: "$asin",
           topitems: {
      $push: { proID: "$_id.asin", text: "$reviewText" }
    }}},
     { $sort: { score: { $meta: "textScore" } } },
     { $limit: 50}
   ]
).map( function (data) {
  data.topitems = data.topitems.slice(0, 10);
  return data;
})	

db.AIV.aggregate(
  [
          { "$sort": { "unixReviewTime": 1} },
          { "$group": {
            "_id": "$asin",
            "items": { "$push": "$$ROOT" $push: { proID: "$_id.asin", date: "$reviewTime" } } 
          }},
          { "$project": {
            "items": { "$slice": [ "$items", 10 ]}
          }},
          { $limit: 50}
  ]
)


db.automotive.createIndex({"reviewText":"text"})
db.automotive.aggregate(
   [
     { $match: { $text: { $search: "highly recommend" } } },
     { $group: { _id: "$asin"}},
     { $sort: { score: { $meta: "textScore" } } },
     { $limit: 50}
   ]
)


db.automotive.aggregate({$group:{_id:"$reviewerID",         
        5: { $sum: { $cond :  [{ $eq : ["$overall", 5]}, 1, 0]} },
		4: { $sum: { $cond :  [{ $eq : ["$overall", 4]}, 1, 0]} },
        3: { $sum: { $cond : [{ $eq : ["$overall", 3]}, 1, 0]} },
        2: { $sum: { $cond :  [{ $eq : ["$overall", 2]}, 1, 0]} },
		1: { $sum: { $cond :  [{ $eq : ["$overall", 1]}, 1, 0]} },
        Total: { $sum: 1 }
    } },{$sort:{Total:-1}},{$limit:10})
	
db.automotive.aggregate({$group:{_id:"$reviewerID", averatings:{$avg:"$overall"}        
        
    } },{$sort:{"averatings":-1}},{$limit:10})
	
db.automotive.aggregate({$group:{_id:"$reviewerID", total:{$sum:1}        
        
    } },{$sort:{"total":-1}},{$limit:10})
	

db.automotive.aggregate({$group:{_id:"$reviewerID", textnum: { $sum: { $cond :  [{ $ne : ["$reviewText", ""]}, 1, 0]} },Total: { $sum: 1 }}},{$sort:{Total:-1}},{$limit:10})

db.automotive.aggregate(
   [
     {
       $group:
         {
           _id: "$reviewerID",
           textitems: {
      $push: { RID: "$_id.reviewerID", Item: "$reviewText" }
    }
    }
     }
   ]
).map( function (data) {
  // Using map here is the best way I could think to limit
  // the array size. Perhaps someone can do it all together
  // But this should do the trick.
  data.textitems = data.textitems.slice(0, 4);
  return data;
})	


var m = function() {
    var words = this.reviewText.split(" ");
    emit(this.reviewerID, words.length);
    }
var r = function(k, v) {
  return Array.sum(v)
}
db.AIV.mapReduce(
    m, r, {out: "word_count"}
)
db.word_count.find().sort({value:-1}).limit(10)



##################

################

##############


db.review.distinct("asin").length
db.review.count()
db.review.count()
db.automotive.find({unixReviewTime: {$exists: true}}, {reviewTime: 1, _id: 0}).sort({unixReviewTime: 1}).limit(1)
e.
db.automotive.aggregate(
   [
     {
       $group:
         {
           _id: "$asin",
           avgReview: { $avg: "$overall" }
         }
     },
     {
        $limit: 50
     }
   ]
)

f:xie
db.automotive.aggregate({ $group:{_id:"$asin",         
        5: { $sum: { $cond :  [{ $eq : ["$overall", 5]}, 1, 0]} },
4: { $sum: { $cond :  [{ $eq : ["$overall", 4]}, 1, 0]} },
        3: { $sum: { $cond : [{ $eq : ["$overall", 3]}, 1, 0]} },
        2: { $sum: { $cond :  [{ $eq : ["$overall", 2]}, 1, 0]} },
1: { $sum: { $cond :  [{ $eq : ["$overall", 1]}, 1, 0]} },
        Total: { $sum: 1 }
    } }, 
    {$project:{5:1, 4:1, 3:1,  2:1, 1:1, Total:1, 
	5: { $divide: [ "$5", "$Total" ]},
	4: { $divide: [ "$4", "$Total" ]},
	3: { $divide: [ "$3", "$Total" ]},
	2: { $divide: [ "$2", "$Total" ]},
	1: { $divide: [ "$1", "$Total" ]}}})


g.
db.automotive.createIndex({"reviewText":"text"})
db.automotive.aggregate(
   [
     { $match: { $text: { $search: "highly recommend" } } },
     { $group: { _id: "$asin"}},
     { $sort: { score: { $meta: "textScore" } } },
    { $project: {"items": { "$slice": [ "$items", 10 ]}}},
     { $limit: 50}
   ]
)
g:xie
db.automotive.createIndex({"reviewText":"text"})
db.automotive.aggregate(
   [
     { $match: { $text: { $search: "highly recommend" } } },
     {
       $group:
         {
           _id: "$asin",
           topitems: {
      $push: { proID: "$_id.asin", text: "$reviewText" }
    }}},
     { $sort: { score: { $meta: "textScore" } } },
     { $limit: 50}
   ]
).map( function (data) {
  data.topitems = data.topitems.slice(0, 10);
  return data;
})	






h.
db.automotive.aggregate(
  [
          { "$sort": { "unixReviewTime": 1} },
          { "$group": {
            "_id": "$asin",
            "items": { "$push": "$$ROOT" $push: { proID: "$_id.asin", date: "$reviewTime" } } 
          }},
          { "$project": {
            "items": { "$slice": [ "$items", 10 ]}
          }},
          { $limit: 50}
  ]
)

db.automotive.aggregate(
  [
          { "$sort": { "unixReviewTime": 1} },
          { "$group": {
            "_id": "$asin",
            "items": { "$push": { proID: "$_id.asin", date: "$reviewTime" } } 
          }},
          { "$project": {
            "items": { "$slice": [ "$items", 10 ]}
          }},
          { $limit: 50}
  ]
)


h:xie
db.automotive.aggregate(
   [
     { $sort: { asin: 1, reviewTime: 1 } },
     {
       $group:
         {
           _id: "$asin",
           topitems: {
      $push: { proID: "$_id.asin", date: "$reviewTime" }
    }
         }
     },{$limit:50}
   ]
).map( function (data) {
  data.topitems = data.topitems.slice(0, 10);
  return data;})	
i.
db.AIV.aggregate(
   [

     {
       $group: { _id: "$reviewerID",
                 count: {$sum: 1}}

     },
     {
       $sort: {'count': -1}
     },
     {
       $limit: 10
     }
   ]
)

j:
var m = function() {
    var words = this.reviewText.split(" ");
    emit(this.reviewerID, words.length);
    }
var r = function(k, v) {
  return Array.sum(v)
}
db.AIV.mapReduce(
    m, r, {out: "word_count"}
)
db.word_count.find().sort({value:-1}).limit(10)



# k: top 10 most positive reviewers based on rating
db.AIV.aggregate(
   [
     {
       $group:
         {
           _id: "$reviewerID",
           avgReview: { $avg: "$overall" }
         }
     },
     {
       $sort: {'avgReview': -1}
     },
     {
        $limit: 10
     }
   ]
)

l:
db.automotive.aggregate(
   [
     { $match: { $text: { $search: "good excellent great awesome" } } },
     {
       $group:
         {
           _id: "$reviewerID",
           topitems: {
      $push: { proID: "$_id.asin", text: "$reviewText" }
    }}},
     { $sort: { score: { $meta: "textScore" } } },
     { $limit: 10}
   ]
)


db.automotive.aggregate({$project:{_id:"$reviewerID",lengthOfReview:{$strLenCP:"$reviewText"}}},{$sort:{lengthOfReview:-1}},{$limit:10})

db.res.find({},{"address.zipcode":1,")



mongoimport --db resto --collection restaurants --drop --file C:\Courses\MSA8050Sp17\Activity\Activity3\primer-dataset.json

show databases 
show collections --> list all the collection
db.restaurants.find() --> list all documents
db.restaurants.count() --> counts the nb of documents in the collection
db.restaurants.find({}, {"address.zipcode":1, _id:0}) --> lists all the zipcodes & suppresses the _id
db.restaurants.distinct("address.zipcode").sort() --> lists the distinct zipcodes

db.restaurants.insert(
   {
      "address" : {
         "street" : "2 Avenue",
         "zipcode" : "10075",
         "building" : "1480",
         "coord" : [ -73.9557413, 40.7720266 ],
      },
      "borough" : "Manhattan",
      "cuisine" : "Italian",
      "grades" : [
         {
            "date" : ISODate("2014-10-01T00:00:00Z"),
            "grade" : "A",
            "score" : 11
         },
         {
            "date" : ISODate("2014-01-16T00:00:00Z"),
            "grade" : "B",
            "score" : 17
         }
      ],
      "name" : "Vella",
      "restaurant_id" : "41704620"
   }
)


db.restaurants.find( { "grades.grade": "B" } )
db.restaurants.find( { "grades.score": { $gt: 30 } } )

db.restaurants.find( { "grades.score": { $gt: 30 } }, {"address.zipcode":1, _id:0} )
db.restaurants.find( { "grades.score": { $gt: 30 } }, {name:1, cuisine:1, _id:0} )

db.restaurants.find(
   { $or: [ { "cuisine": "Italian" }, { "address.zipcode": "10075" } ] }
)


db.restaurants.find({$or: [ { "cuisine": "Italian" }, { "address.zipcode": "10075" } ]},{name:1, cuisine:1, _id:0})


db.restaurants.find().sort( { "borough": 1, "address.zipcode": 1 } )







db.restaurants.update(
    { "name" : "Juni" },
    {
      $set: { "cuisine": "American (New)" },
      $currentDate: { "lastModified": true }
    }
)



db.restaurants.update(
  { "restaurant_id" : "41156888" },
  { $set: { "address.street": "East 31st Street" } }
)




db.restaurants.update(
  { "address.zipcode": "10016", cuisine: "Other" },
  {
    $set: { cuisine: "Category To Be Determined" },
    $currentDate: { "lastModified": true }
  },
  { multi: true}
)



db.restaurants.update(
   { "restaurant_id" : "41704620" },
   {
     "name" : "Vella 2",
     "address" : {
              "coord" : [ -73.9557413, 40.7720266 ],
              "building" : "1480",
              "street" : "2 Avenue",
              "zipcode" : "10075"
     }
   }
)

db.restaurants.find({"restaurant_id": "41704620"})
db.restaurants.update(
   { "restaurant_id" : "41704620" },
   {
     "name" : "Vella 2",
     "address" : {
              "coord" : [ -73.9557413, 40.7720266 ],
              "building" : "1480",
              "street" : "2 Avenue",
              "zipcode" : "10075"
     }
   }
)




db.restaurants.aggregate(
   [
     { $group: { "_id": "$borough", "count": { $sum: 1 } } }
   ]
);







db.restaurants.createIndex( { cuisine: "text" } )
db.restaurants.find( { }, {name:1, cuisine:1, _id:0} )
db.restaurants.distinct( "cuisine" ).sort()

db.restaurants.find( { $text: { $search: "ice" } } , {name:1, _id:0})

db.restaurants.find( { $text: { $search: "ice" } } )



db.restaurants.find(
   { $text: { $search: "ice" } },
   { score: { $meta: "textScore" } }
)



db.restaurants.aggregate(
   [
     { $match: { $text: { $search: "ice" } } },
     { $sort: { score: { $meta: "textScore" } } },
     { $project: { name: 1,score:1, _id: 1 } }
   ]
)


Greater Than Operator ($gt)

db.restaurants.find( { "grades.score": { $gt: 30 } } )


Less Than Operator ($lt)

db.restaurants.find( { "grades.score": { $lt: 10 } } )


Logical AND

db.restaurants.find( { "cuisine": "Italian", "address.zipcode": "10075" } )


Logical OR

db.restaurants.find(   
{ $or: 
[ 
{ "cuisine": "Italian" }, { "address.zipcode": "10075" }, {"grades.score": { $lt: 35 } }
] 
}
).limit(100).skip(1290)


Sort query results

db.restaurants.find().sort( { "borough": 1, "address.zipcode": 1 } )
)


> db.automotive.aggregate({$group:{_id:{rate:"$overall",proID:"$asin"},count:{$s
um:1}}},{$project:{"rate":-1}},{$limit:50})
> db.res.aggregate({$group:{_id:"$borough", count:{$sum:1}}})


#####################
#####################
######################
mini4
a:
db.review.aggregate(
   [
     {
       $group:
         {
           _id: "$reviewerID",
           firstreviewTime: { $first: "$unixReviewTime" }
         }},
     {$sort:{"firstreviewTime":1}},{$limit:10}
   ]
)

b:
db.review.aggregate(
   [
     {
       $group:
         {
           _id: "$reviewerID",
           lastreviewTime: { $last: "$unixReviewTime" }
         }},
     {$sort:{"lastreviewTime":-1}},{$limit:10}
   ]
)
c:
db.review.aggregate(
   [{$sort:{"unixReviewTime":1}},
     {
       $group:
         {
           _id: "$reviewerID",
           firstreviewTime: { $first: "$unixReviewTime" },lastreviewTime: { $last: "$unixReviewTime" }
         }},  { $project: { firstreviewTime: 1, lastreviewTime:1, dateDifference: { $subtract: [ "$lastreviewTime","$firstreviewTime"] } } }, {$sort:{"dateDifference":-1}},{$limit:1}
   ]
)

db.review.aggregate(
   [
     {
       $group:
         {
           _id: "$reviewerID",
           firstreviewTime: { $first: "$unixReviewTime" },lastreviewTime: { $last: "$unixReviewTime" }
         }},  { $project: { firstreviewTime: 1, lastreviewTime:1, dateDifference: { $subtract: [ "$lastreviewTime","$firstreviewTime"] } } }, {$sort:{"dateDifference":-1}},{$limit:1}
   ]
)


d:

db.review.aggregate([
   { $group: { _id: "$reviewerID", stdDev: { $stdDevPop: "$overall" } } },{ $sort: {"stdDev":-1}},{$limit:10}
   
])

e:

db.review.aggregate([
   { $group: { _id: "$asin", stdDev: { $stdDevPop: "$overall" } } },{ $sort: {"stdDev":-1}},{$limit:10}
   
])
*************

db.automotive.aggregate([

  {
      $lookup:
        {
          from: "automotive_meta",
          localField: "asin",
          foreignField: "asin",
          as: "meta_docs"
        }
   },{ $unwind: "$meta_docs"},{$project:{"meta_docs.price":1,"reviewerID":1,"_id":0}}
])

***************


f:
db.review.aggregate( [{$match:{"reviewerID":{$in:["A2C6XQCFSQCXF6", "A1AX6ZRCFNTSM0", "A1PXMMDEQIEKMN","AAN5MYE2X0FMX", "A2R5260XQZ9WF5"]}}},
                      { $group : { _id : {reviewerID: "$reviewerID"}, Pro: { $push: "$asin" } } },
                      { $out : "Plist" }
                  ] )
db.Plist.aggregate( [
                      { $group : { _id :{asin:"$Pro"}, ReviewerID: { $push: "$_id.reviewerID" }, size: {$sum: 1} } },
 {$sort: {size: -1}}] )
 
 
 db.review.aggregate( [{ $sample: { size: 5 } },
                      { $group : { _id : {reviewerID: "$reviewerID"}, Pro: { $push: "$asin" } } },
                      { $out : "Plist" }
                  ] )
db.Plist.aggregate( [
                      { $group : { _id :{asin:"$Pro"}, ReviewerID: { $push: "$_id.reviewerID" }, size: {$sum: 1} } },
 {$sort: {size: -1}}] )
 
 
 

g:
db.review.aggregate({$group:{_id:{proID:"$asin", time:"$unixReviewTime"},reviewer:{$push:"$reviewerID"}}})



***************
db.automotive_meta.aggregate([

  {
      $lookup:
        {
          from: "automotive",
          localField: "asin",
          foreignField: "asin",
          as: "meta_docs"
        }
   },{
      $match: { "meta_docs": { $ne: [] } }
   }])

**************


db.authors.aggregate({$group:{_id:"$meta_docs.reviewerID", stdDev: { $stdDevPop: "$price" } } },{ $sort: {"stdDev":-1}},{$limit:10})




#############
mini project5O


LOAD CSV WITH HEADERS FROM 
'file:///C:/Review_5.csv' AS line 
WITH line 

CREATE (review: review {id: line.`reviewID`})
MERGE(product: product {id: line.`asin`})
MERGE (reviewer: reviewer {id: line.`reviewerID`})

CREATE (product)-[:HAS]->(review)
CREATE (reviewer )-[:POST {unixtime: line.`unixReviewTime`, time:line.`reviewTime`}]->(review )


MATCH (p:product)-[:HAS]->(review)<-[:POST]-(re: reviwer)
RETURN p.id, re.id
LIMIT 5



a-	Identify the products that a reviewer has reviewed (limit to 5 reviewers) [10pts].
MATCH (p:product)-[:HAS]->(review)<-[:POST]-(re: reviwer)
RETURN p.id, re.id
LIMIT 5
b-	Identify the reviewer with the most number of reviews [10pts].
MATCH (r:reviewer)-[:POST]->(review)
WITH r, count(review) AS score
ORDER BY score DESC
LIMIT 1
RETURN r.id, score
c-	Identify the reviewer with the newest review [10pts].
MATCH (r:reviewer)-[p:POST]->(review)
RETURN r.id, max (p.unixtime)  AS newest, p.time
ORDER BY newest DESC
LIMIT 1

d-	Identify the reviewer who has been reviewing for the longest period of time

MATCH(r:reviewer)-[p:POST]->(review)
SET p.unixReviewTime=toInt(p.unixReviewTime)
WITH r, p, max(p.unixReviewTime) as oldtime, min(p.unixReviewTime) as newtime
RETURN r.id, oldtime,newtime, oldtime-newtime as diff
ORDER BY diff DESC
LIMIT 1


db.review.aggregate({$group:{_id:{rate:"$overall",proID:"$asin"},count:{$sum:1}}},{$project:{count:1}},{$limit:50})


db.business.aggregate({$group: { "_id": "$city", "count": { $sum: 1 } }},{$sort:{"count":-1}},{$limit:10})

db.business.find({ $or: 
[ 
{ "city": "Cleveland" }, {"city":"Henderson"}
] 
},{$limit:5})







####################




db.Madisoncity.aggregate({$lookup:{from:"review",localField:"business_id",foreignField:"business_id", as:"Madisonreview"}},{$out:"Mreview"})

db.Madisoncity.aggregate({$lookup:{from:"review",localField:"business_id",foreignField:"business_id", as:"Madisonreview"}},{$out:"Mreview"})
db.Madisoncity.aggregate({$lookup:{from:"MadisonReview",localField:"business_id",foreignField:"business_id", as:"Mdreview"}},{$out:"Mreview"})

db.Mreview.aggregate({$lookup:{from:"user",localField:"Mdreview.user_id",foreignField:"user_id", as:"Fuser"}},{$out:"buser"})


db.getCollection('user').aggregate([
    {
        $lookup: {
            from: "Madisoncity",
            localField: "business_id",
            foreignField: "business_id",
            as: "userInfoData"
        }
    },
    {
        $lookup: {
            from: "MadisonReview",
            localField: "user_id",
            foreignField: "user_id",
            as: "userRoleData"
        }
    },
    { $unwind: { path: "$userInfoData", preserveNullAndEmptyArrays: true }},
    { $unwind: { path: "$userRoleData", preserveNullAndEmptyArrays: true }}
])


db.Mreview.aggregate( [
   { $unwind: { path: "$Mdreview", preserveNullAndEmptyArrays: true }}
] )






db.MadisonUser.aggregate([
    {
        $lookup: {
            from: "Madisoncity",
            localField: "business_id",
            foreignField: "business_id",
            as: "userBusiness"
        }
    },
    {
        $lookup: {
            from: "MadisonReview",
            localField: "user_id",
            foreignField: "user_id",
            as: "userReview"
        }
    },
    { $unwind: { path: "$userBusiness", preserveNullAndEmptyArrays: true }},
    { $unwind: { path: "$userReview", preserveNullAndEmptyArrays: true }}
])


db.user.aggregate({$lookup:{from:"MadisonReview",localField:"user_id",foreignField:"user_id", as:"Ureview"}},{$out:"Ureview"})


db.sivaUserInfo.aggregate([
    {$lookup:
        {
           from: "sivaUserRole",
           localField: "userId",
           foreignField: "userId",
           as: "userRole"
        }
    },
    {
        $unwind:"$userRole"
    },
    {
        $project:{
            "_id":1,
            "userId" : 1,
            "phone" : 1,
            "role" :"$userRole.role"
        }
    },
    {
        $out:"sivaUserTmp"
    }
])


db.sivaUserTmp.aggregate([
    {$lookup:
        {
           from: "sivaUser",
           localField: "userId",
           foreignField: "userId",
           as: "user"
        }
    },
    {
        $unwind:"$user"
    },
    {
        $project:{
            "_id":1,
            "userId" : 1,
            "phone" : 1,
            "role" :1,
            "email" : "$user.email",
            "userName" : "$user.userName"
        }
    }
])




db.business.aggregate({$group: { "_id": "$city", "count": { $sum: 1 } }},{$sort:{"count":-1}},{$limit:50})


db.business.aggregate({$match:{"city":"Madison"}},{$out:"Madisoncity"})
t=db.Madisoncity.distinct("business_id")
db.review.aggregate([{$match:{"business_id":{$in: t}}},{$out:"MadisonReview"}])

db.Madisoncity.aggregate({$lookup:{from:"MadisonReview",localField:"business_id",foreignField:"business_id", as:"Mdreview"}},{$out:"Mreview"})

t=db.MadisonReview.distinct("user_id")
db.user.aggregate([{$match:{"user_id":{$in: t}}},{$out:"MadisonUser"}])




 db.freview.aggregate({$group:{_id:"$stars",         
        total: { $sum: { $cond : [{ $le: ["$stars", 3]}, 1, 0]} }
    } })

db.freview.find( { stars: { $lt: 3 } } ).count()
 db.freview.find( { stars: { $gt: 3 } } ).count()



db.freview.aggregate(
{ $group: { "_id": "$business_id", "average": { $avg: "$stars" } } },
{ $limit: 50 }
)


db.Madisoncity.aggregate({$group:{_id:"$categories", "total":{$sum:1}}},{$sort : {total : -1 } },{$limit:5})



db.Mreview.aggregate({$group:{_id:"$categories"}},{$sort: {"categories" : 1, "Mdreview.date": -1}},{$project:{Data:"Mdreview.date"}},{$limit:5})

db.Mreview.aggregate({$group:{_id:"$categories"}}).sort(Mdreview.date": -1)


db.MadisonReview.aggregate(
[
{ $group: {_id : "$user_id", reviewCount: { $sum: 1 } } },
{$sort : {reviewCount : -1 } },
{$limit :10}
]
)

db.MadisonReview.aggregate(
[
{ $group: {_id:"$user_id", verbose: {$sum: {$strLenCP: "$text" } } } },
{$sort:{verbose:-1}},
{$limit:10}
]
)









##########################33



db.MadisonUser.aggregate([
    {
        $lookup: {
            from: "Madisoncity",
            localField: "business_id",
            foreignField: "business_id",
            as: "userBusiness"
        }
    },
    {
        $lookup: {
            from: "MadisonReview",
            localField: "user_id",
            foreignField: "user_id",
            as: "userReview"
        }
    },
    { $unwind: { path: "$userBusiness", preserveNullAndEmptyArrays: true }},
    { $unwind: { path: "$userReview", preserveNullAndEmptyArrays: true }}
])

db.MadisonReview.aggregate({ $lookup: {
            from: "MadisonUser",
            localField: "user_id",
            foreignField: "user_id",
            as: "userReview"
        }},{ $unwind: { path: "$userBusiness", preserveNullAndEmptyArrays: true }},{$out:"userreview"})
		
		
		
		
		
		
		
		
		
		
		
		
		
		
# Earliest date of review per category:
db.Mreview.aggregate(
   [
     {
       $unwind: "$categories"
     },
     {
       $unwind: "$Mdreview"
     },
     {
       $group:
         {
           _id: "$categories",
           "minDate": {"$min" : "$Mdreview.date"}
         }
     },
     {
       $limit: 10
     }
   ]
)




# avg rating per category:
db.Mreview.aggregate(
   [
     {
       $unwind: "$categories"
     },
     {
       $unwind: "$Mdreview"
     },
     {
       $group:
         {
           _id: "$categories",
           avgReview: { $avg: "$Mdreview.stars" }
         },
     },
     {
        $sort : {avgReview: -1}
     },
     {
        $limit: 10
     }
   ]
)


db.MadisonReview.aggregate(
   [
     {
       $group: { _id: "$business_id",
                 count: {$sum: 1}}
     },
     {
       $sort: {'count': -1}
     },
     {
       $limit: 10
     }
   ]
)




# rating histogram per category:
db.Mreview.aggregate(
[
  {
    $unwind: "$categories"
  },
  {
    $unwind: "$Mdreview"
  },
  {
    $group:  {_id:"$categories",
          5: { $sum: { $cond :  [{ $eq : ["$Mdreview.stars", 5]}, 1, 0]} },
          4: { $sum: { $cond :  [{ $eq : ["$Mdreview.stars", 4]}, 1, 0]} },
          3: { $sum: { $cond :  [{ $eq : ["$Mreview.stars", 3]}, 1, 0]} },
          2: { $sum: { $cond :  [{ $eq : ["$Mreview.stars", 2]}, 1, 0]} },
          1: { $sum: { $cond :  [{ $eq : ["$Mreview.stars", 1]}, 1, 0]} },
          Total: { $sum: 1 }
      }
   },
   {
     $project:{5:1, 4:1, 3:1,  2:1, 1:1, Total:1,
            	5: { $divide: [ "$5", "$Total" ]},
            	4: { $divide: [ "$4", "$Total" ]},
            	3: { $divide: [ "$3", "$Total" ]},
            	2: { $divide: [ "$2", "$Total" ]},
            	1: { $divide: [ "$1", "$Total" ]}}}
]
)



# top 10 business with most consistent review
db.Mreview.aggregate(
   [
     {
       $unwind: "$Mdreview"
     },
     {
       $group:
         {
           _id: "$business_id",
           count: { $sum: 1 },
           stdDev: { $stdDevPop: "$Mdreview.stars"}
         }
     },
     { $match: { count: { $gt: 30 } } },
     {
        $sort : {stdDev: 1}
     },
     {
        $limit: 10
     }
   ]
)



db.Mreview.aggregate(
[
  {
    $unwind: "$categories"
  },
  {
    $unwind: "$Mdreview"
  },{$match:{categories:"Beer Gardens"}},
  {
    $group:  {_id:"$categories",
          positive: { $sum: { $cond :  [{ $gt : ["$Mdreview.stars", 3]}, 1, 0]} },
		  neutral: { $sum: { $cond :  [{ $eq : ["$Mdreview.stars", 3]}, 1, 0]} },
          negative: { $sum: { $cond :  [{ $lt : ["$Mdreview.stars", 3]}, 1, 0]} },
          Total: { $sum: 1 }
      }
   },{$sort:{Total:-1}}
   {
     $project:{positive:1, negative:1,Total:1,
            	positive: { $divide: [ "$positive", "$Total" ]},
				neutral: { $divide: [ "$neutral", "$Total" ]},
            	negative: { $divide: [ "$negative", "$Total" ]},
            }}
]
)



db.Mreview.aggregate(
[
  {
    $unwind: "$categories"
  },
  {
    $unwind: "$Mdreview"
  },
  {
    $group:  {_id:"$categories",
          positive: { $sum: { $cond :  [{ $gt : ["$Mdreview.stars", 3]}, 1, 0]} },
		  neutral: { $sum: { $cond :  [{ $eq : ["$Mdreview.stars", 3]}, 1, 0]} },
          negative: { $sum: { $cond :  [{ $lt : ["$Mdreview.stars", 3]}, 1, 0]} },
          Total: { $sum: 1 }
      }
   },{$sort:{"Total":-1}},
   {
     $project:{positive:1, negative:1,Total:1,
            	positive: { $divide: [ "$positive", "$Total" ]},
				neutral: { $divide: [ "$neutral", "$Total" ]},
            	negative: { $divide: [ "$negative", "$Total" ]},
            }}
]
)


db.Mreview.aggregate(
[
  {
    $unwind: "$categories"
  },
  {
    $unwind: "$Mdreview"
  },
  {
    $group:  {_id:"$categories",
          positive: { $sum: { $cond :  [{ $gt : ["$Mdreview.stars", 3]}, 1, 0]} },
		  neutral: { $sum: { $cond :  [{ $eq : ["$Mdreview.stars", 3]}, 1, 0]} },
          negative: { $sum: { $cond :  [{ $lt : ["$Mdreview.stars", 3]}, 1, 0]} },
          Total: { $sum: 1 }
      }
   },
   {
     $project:{positive:1, negative:1,Total:1,
            	positive: { $divide: [ "$positive", "$Total" ]},
				neutral: { $divide: [ "$neutral", "$Total" ]},
            	negative: { $divide: [ "$negative", "$Total" ]},
            }},{$sort:{"negative":-1}}
]
)











