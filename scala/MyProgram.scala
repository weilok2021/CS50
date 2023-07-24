import java.io.FileReader
import com.opencsv.CSVReader

case class Gdp(val country: String, val series: String,val value: Double){
    def computeAverage(total: Double, n: Int):Int={
        return (total / n).asInstanceOf[Int]
    }
}

object MyProgram extends App{
    val filePath = "gdpdata.csv"
    val fileReader = new FileReader(filePath)
    val csvReader = new CSVReader(fileReader)
    val header = csvReader.readNext()
    
    // implement List(Map(k , v)) collection to store records in csv file in the form of List[Map(header, column)]
    val dataList = scala.collection.mutable.ListBuffer.empty[Map[String, String]]

    // keep track of average country name and average gdp using (key, value) pair
    var averages = scala.collection.mutable.Map[String, Int]()

    // load csv data into dataList
    loadFile()

    csvReader.close()
    
    // convert listbuffer to immutable list
    dataList.toList

    // keep track of highest gdp and country name
    var hGdp: Double = 0
    var hCountry:String = ""

    // to compute averages and keep track of country name
    var sum: Double = 0
    var n: Int = 0
    var aCountry: String = ""
    var aGdp: Int = 1000000; 
    


    // instantiate gdp
    var gdp = Gdp("", "", 0)
    // searching starts from 841 rows excluding regions
    for (i <- dataList.drop(840)){
        gdp = Gdp(i("Region/Country/Area"), i("Series"), i("Value").replace(",", "").toDouble)

        // solve question 1
        if (gdp.value > hGdp && gdp.series.equals("GDP per capita (US dollars)")){
            hGdp = gdp.value
            //gdp.hGdp = hGdp
            hCountry = gdp.country
            //gdp.hCountry = hCountry
        }
        
        if (gdp.series.equals("GDP per capita (US dollars)")){
            // if get to new country compute current country average and reset total sum and total n.
            // compute countries averages gdp per capita
            // to solve question 2 and question 3
            if (!aCountry.equals(gdp.country) && !gdp.country.equals("Afghanistan")){
                aGdp = gdp.computeAverage(sum, n)
                averages(aCountry) = aGdp
                sum = 0
                n = 0
            }
            // else sum up current country gdp, keep track of country name and increment n
            aCountry = gdp.country
            sum = sum + gdp.value
            n = n + 1
        }
    }

// Sort the countries based on their average GDP in ascending order
    val sortedCountries = averages.toSeq.sortBy(_._2)

    // Select the top 5 countries with the lowest average GDP
    val top5LowestGDP = sortedCountries.take(5)
    
    // output of question 1
    println(s"The country with highest gdp per capital(US dollars) ${hGdp.asInstanceOf[Int]} is ${hCountry}.\n")
    
    // output of question 2
    println(s"The average GDP per capital (US dollars) for Malaysia is ${averages("Malaysia")}.\n")
    
    //output of question 3
    // Print the top 5 countries with their average GDP
    println("The five countries with lowest average GDP per capital(US dollars) are: ")
    top5LowestGDP.foreach { case (country, averageGDP) =>
      println(s"Country: $country, Average GDP per capital(US dollars): $averageGDP")
    }
    
    def loadFile(){
        // add each row in csv into a list as a map in the form list[map(header, column)]
        var record: Array[String] = null
        while ({ record = csvReader.readNext(); record != null }) {
          val rowMap = header.zip(record).toMap
          dataList += rowMap
        }    
    }
}
