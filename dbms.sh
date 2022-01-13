#!/bin/bash


######## Assisting Variables #############
line () {
	echo "------------------------------------------------"
}


######## Intro Functions    ##############
# Welcome intro
welcome_intro () {
	echo -e "------------------DBMS Project------------------\n                     Done By\n             Aya Maged Mohamed Ibrahem\n             Ahmed Mahmoud Saleh Ibrahem\nITI-Minia Branch Q2 2021-2022\nFull Stack Web Development using Python Group-1"
	line
}

######## Table Functions    ##############
#/////create table//////

createtable () {
	echo "enter table name :"
	read tablename


	if [[ -f $tablename ]]
	then
		echo "table already existed ,choose another name"

	else
		typeset -i numberofcolumn
		echo "enter number of column "
		read numberofcolumn
		echo $((numberofcolumn * numberofcolumn)) 

		typeset columnnames[$numberofcolumn]
		typeset columnprivlages[$numberofcolumn]
		counter=0
		# //to read data from user///
		while [ $counter -lt $numberofcolumn ]
		do

			echo "enter column name to number $((counter+1)) "
			read val
			columnnames[counter]=$val
			echo  ${columnnames[$counter]}

			echo "enter data type to column  number $((counter+1)) "
			select d in int string
			do
				case $REPLY in

					1) columnprivlages[$counter]="int"
						break;;
					2) columnprivlages[$counter]="string"
						break;;
					*) echo "wrong awnser"
						break;;

					esac
				done


				let counter=$counter+1

			done
			#///// to make file and add data type  and columns name 

			datatype_row=""
			columnname_row=""
			counter=0
			while [ $counter -lt $numberofcolumn ]
			do
				datatype_row=$datatype_row""${columnprivlages[$counter]}"|"
				columnname_row=$columnname_row""${columnnames[$counter]}"|"
				let counter=$counter+1

			done


			touch $tablename
			touch metadata/metadata_${tablename}

			echo $numberofcolumn>>metadata/metadata_$tablename
			echo "$datatype_row">>metadata/metadata_$tablename
			echo "$columnname_row">>metadata/metadata_$tablename
			echo "table created sucessfully"

	fi

}



#//// insert into table /////

function insert_into_table {

	echo "enter table name :"
	read tablename
	echo $tablename

	if ! [[ -f $tablename ]]
	then
		echo "table not existed :("
	else
		numberofcolumn=$(awk  'BEGIN{FS="|";}{if (NR==1) print $1}' metadata/metadata_$tablename)
		counter=0
		typeset column_names[$numberofcolumn]

		typeset mydata[$numberofcolumn]




		while [ $counter -lt $numberofcolumn ]

		do
			column_names[$counter]=$(awk 'BEGIN{FS="|";}{if (NR==3) print $0}' metadata/metadata_$tablename)
			echo "enter column value to column $((counter+1)) ${column_names[$counter]} "
			read val
			mydata[$counter]=$val

			let counter=$counter+1

		done




		column_row_values=""
		counter=0
		while [ $counter -lt $numberofcolumn ]
		do

			column_row_values=$column_row_values""${mydata[$counter]}"|"
			let counter=$counter+1

		done


		echo "$column_row_values">>$tablename

		echo "insertion done successfully :)"


	fi
}
# delete from table
delete_from_table () {
	if [[ $# -eq 0 ]]
	then
		echo "Nothing was selected"
		line
		table_screen

	elif [[ $# -eq 1 ]]
	then
		if [[ -f $1 ]]
		then
			table=$1
			echo please insert the primary key value where the record will be deleted
			read pk
			if [[ $pk != "" ]]
			then
				sed -i -r "/^$pk/d" $table
				echo Record deleted successfully
				line
				table_screen
			else
				echo "Nothing was inserted"
				line
				table_screen
			fi

		else
			echo "Table $1 doesn't exist"
			line
			table_screen
		fi
	else
		echo Invaild input, please try again
		line
		table_screen
	fi
}

# drop table
drop_table () {
	if [[ $# -eq 0 ]]
	then
		echo "Nothing was selected"
		line
		table_screen
	elif [[ $# -eq 1 ]]
	then 
		if [[ -f $1 ]]
		then
			table=$1
			select c in "Are you sure you want to drop table $table ? Type 1 for YES 2 for NO" 
			do
				case $REPLY in
					1) rm $table
						echo $table was dropped successfully
						line
						table_screen
						;;
					2) table_screen;;
					*) echo Sorry invaild select,try again 1 for YES or 2 for No
						;;
				esac
			done

		else 
			echo "Table $1 doesn't exist"
			line
			table_screen
		fi
	else 
		echo Invaild input, please try again
		line
		table_screen
	fi
}


# select from table
select_table () {
	if [[ $# -eq 0 ]]
	then
		echo "Nothing was selected"
		line
		table_screen

	elif [[ $# -eq 1 ]]
	then
		if [[ -f $1 ]]
		then
			table=$1
			select c in "Type 1 Select all table" "Type 2 Select a record" "Type r to return or e to exit"
			do
				case $REPLY in
					1) awk 'BEGIN{FS="|";} {print $0}' $table
						echo "Type r to return or e to exit"
						;;
					2) echo please insert the value of primary key
						read pk
						if [[ $pk != "" ]]
						then
							awk 'BEGIN{FS="|";} {print $0}' $table|grep ^$pk
							echo "Type r to return or e to exit"
						else
							echo "Nothing was inserted"
							echo "Type 1 Select all table or 2 Select a record" 
							echo "Type r to return or e to exit"
						fi
						;;
					"r")table_screen;;
					"e")exit;;
					*) echo "Sorry not valid select, please select from above"
						;;
				esac
			done
		else
			echo "Table $1 doesn't exist"
			line
			table_screen
		fi
	else
		echo Invaild input, please try again
		line
		table_screen
	fi
}

#////list tables //////

function list_all_tables {
	ls -f
}

function update_table {


	echo "enter table name :"
	read tablename
	echo $tablename

	if ! [[ -f $tablename ]]
	then
		echo "table not existed :("
	else


		select character in "update all rows" "update one row"
		do

			case $REPLY in

				1)	echo "enter old word"
					read vale2
					echo "enter new word"
					read vale3
					sed -i -r s/$vale2/$vale3/g $tablename
					echo "done ......"
					;;
				2)  echo "enter row number "
					read vale
					echo "enter old word"
					read vale2
					echo "enter new word"
					read vale3


					sed -i -r $((vale))s/$vale2/$vale3/  $tablename
					echo "done ......"

					;;

				*) echo "wrong chosse :(" ;;


			esac
		done



	fi


}


#///// Drop tables //////
table_screen () {
	line
	select c in "Type 1 Create Table" "Type 2 Update Table" "Type 3 Insert Into Table" "Type 4 Drop Table" "Type 5 Select Table" "Type 6 Delete from table" "Type 7 List Tables" "Type r to return or e to exit"
	do
		case $REPLY in
			1) createtable ;;
			2) update_table
				;;
			3) insert_into_table
				;;
			4) echo please enter table name:
				read table
				drop_table $table
				;;
			5) echo Please enter table name:
				read table
				select_table $table
				;;
			6) echo Please enter table name:
				read table
				delete_from_table $table
				;;
			7) list_all_tables
				;;
			"r") dbms_screen;;
			"e")exit;;
			*) echo Invalid input, please try again
				;;
		esac
	done

}

######## Database Functions ##############
# create database
create_db () {
	line
	echo Create Database
	select c in "Please enter the new Database name:" "Type r to Return or e to Exit"
	do
		case $REPLY in
			"") echo Nothing was inserted
				;;
			*\ *) echo Invalid input, Please try again
				;;
			"e") exit;;
			"r") 	dbms_screen
				;;
			*)if ! [[ -d $REPLY ]]
			then
				mkdir $REPLY
				cd $REPLY; mkdir metadata; chmod +rwx metadata;
				echo Created database $REPLY
				echo Type r to Return or e to Exit
			else
				echo This name exist, please enter a new name

				create_db
			fi

			;;
	esac
done
}
# drop database
drop_db () {
	line
	echo Drop Database
	select c in "Please enter the Database name:" "Type r to Return or e to Exit"
	do      
		case $REPLY in
			"") echo Nothing was inserted
				;;
			*\ *) echo Invalid input, Please try again
				;;
			"e") exit;;
			"r")    dbms_screen
				;;
			*)if [[ -d $REPLY ]]
			then    
				rm -r $REPLY
				echo  Dropped database $REPLY 
				echo  Type r to Return or e to Exit
			else    
				echo This database does not exist, please enter a database name
				drop_db
			fi

			;;
	esac
done
}

# connect database
connect_db () {
	line
	echo Connect to Database
	select c in "Please enter the Database name:" "Type r to Return or e to Exit"
	do
		case $REPLY in
			"") echo Nothing was inserted
				;;
			*\ *) echo Invalid input, Please try again
				;;
			"e") exit;;
			"r")  dbms_screen
				;;
			*)if [[ -d $REPLY ]]
			then
				cd $REPLY
				echo  Connected to database $REPLY
				echo `pwd`
				table_screen
				echo  Type r to Return or e to Exit
			else
				echo This database does not exist, please enter a database name
				connect_db
			fi

			;;
	esac
done
}

# list databases
list_dbs () {
	line
	cd ~/dbms
	echo  List Databases
	ls -d */ | cut -f1 -d'/'
	echo  Type r to Return or e to Exit
	read
	case $REPLY in
		"r")dbms_screen
			;;
		"e")exit;;
		*)echo Not vaild choise
			list_dbs
			;;
	esac

}

db_screen () {
	cd ~/dbms
	pwd
	select c in "Type 1 Create Database" "Type 2 Drop Database" "Type 3 Connect to Database" "Type 4 List Databases" "Type 5 Exit"
	do
		case $REPLY in
			1) create_db
				;;
			2) drop_db
				;;
			3) connect_db
				;;
			4) list_dbs
				;;
			5) exit;;
			*) echo Invaild input, please try again
				;;

			esac
		done
	}


######## DBMS Calling ##############
dbms_screen () {
	# intro screen
	welcome_intro
	db_screen
	#	table_screen
}
dbms_screen

