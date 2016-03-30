
import com.cloudera.search.queries.IdQuery

val claims = Array( "CZ", "KOLN", "KAT", "KONSOLA" )

val distClaims = sc.parallelize( claims )

val qr = distClaims.map( _ => IdQuery.query( _ )  )

qr.saveAsTextFile("q1")

distClaims.saveAsTextFile("c1")


