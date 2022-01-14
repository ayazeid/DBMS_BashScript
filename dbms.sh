#!/bin/bash


######## Assisting functions  #############
line () {
	echo "------------------------------------------------"
}

input_check () {
	if [ $# -eq 1 -a -n "$1" ]
	then
		return 0
	else
		return 1
	fi
}

int_check () {
	if [[ $1 =~ ^[+-]?[0-9]+$ ]]; then
		return 0
	else return 1
	fi
}

pk_check () {
	#for p in `cut -f1 -d'|' $2`
	#do
	#	if [ $p -eq $1 ]
	#	then
	#		return 1
	#	fi
	#done
	if `grep -q $1 $2`
	then
		echo flase
		return 1
	else echo true
		return 0
	fi
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
	line
	echo "Please enter table name :"
	read tablename
	if input_check $tablename;
	then 
		if [[ -f $tablename ]]
		then
			echo "Table already existed ,please choose another name"
			createtable
		else
			#typeset -i numberofcolumn
			echo "Please enter number of column "
			read numberofcolumn
			if int_check $numberofcolumn;
			then 
				#echo $((numberofcolumn * numberofcolumn)) 

				typeset columnnames[$numberofcolumn]
				typeset columnprivlages[$numberofcolumn]
				counter=0
				# //to read data from user///
				while [ $counter -lt $numberofcolumn ]
				do
					if [ $((counter+1)) == 1 ] 
					then 
						echo "Please enter name to column number $((counter+1)) ( Primary key ) "
						read val
						if input_check $val;
						then
							columnnames[counter]=$val
							#       echo  ${columnnames[$counter]}

							echo "Please enter data type to column  number $((counter+1))   ( ${columnnames[$counter]} ) "
							select d in int string
							do
								case $REPLY in

									1) columnprivlages[$counter]="int"
										break;;
									2) columnprivlages[$counter]="string"
										break;;
									*) echo "Wrong awnser"
										createtable

									esac
								done


								let counter=$counter+1
							else echo Invalid input, Please try again
								counter=$counter
						fi

					else


						echo "Please enter name to column number $((counter+1)) "
						read val
						if input_check $val;
						then
							columnnames[counter]=$val
							#	echo  ${columnnames[$counter]}

							echo "Please enter data type to column  number $((counter+1))   ( ${columnnames[$counter]} ) "
							select d in int string
							do
								case $REPLY in

									1) columnprivlages[$counter]="int"
										break;;
									2) columnprivlages[$counter]="string"
										break;;
									*) echo "Wrong awnser"
										createtable

									esac
								done


								let counter=$counter+1
							else echo Invalid input, Please try again
								counter=$counter
						fi
					fi
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
				echo "Table $tablename created sucessfully"
				table_screen

			else echo Invalid input, please try again
				createtable
			fi  
		fi
	else echo Invaild input, please try again
		createtable
	fi
}



#//// insert into table /////

function insert_into_table {
	line
	echo "Please enter table name :"
	read tablename
	echo $tablename

	if ! [[ -f $tablename ]]
	then
		echo "Table not existed, please try again"
		insert_into_table
	else
		numberofcolumn=$(awk  'BEGIN{FS="|";}{if (NR==1) print $1}' metadata/metadata_$tablename)
		counter=0
		typeset column_names[$numberofcolumn]

		typeset mydata[$numberofcolumn]




		while [ $counter -lt $numberofcolumn ]

		do
			column_names[$counter]=$(awk 'BEGIN{FS="|";}{if (NR==3) print $0}' metadata/metadata_$tablename)
			dt=$(awk -v dt="$((counter+1))"  'BEGIN{FS="|";}{if (NR==2) print $dt}' metadata/metadata_$tablename)
			col=$(awk -v col="$((counter+1))"  'BEGIN{FS="|";}{if (NR==3) print $col}' metadata/metadata_$tablename)



			if [ $((counter+1)) == 1 ]
			then

				echo "Please enter $dt data type value to the Primary key  column $((counter+1)) ( $col )"
				read val
				pk=$(awk 'BEGIN{FS="|";} {print $1}' $table|grep -q -x $val; echo $?)
				if [ $dt == "int" ]
				then
					#pk=grep $val $table;
					if int_check $val;
					then
						if [ $pk == 1 ]
						then
							echo $pk
							mydata[$counter]=$val
							let     counter=$counter+1
						else echo Primary key exist, please try again with unique new value
							counter=$counter
						fi
						#	mydata[$counter]=$val
						#	let	counter=$counter+1
					else
						echo Invaild input data type, please try again
						counter=$counter
					fi
				else
					if input_check $val;
					then
						if [ $pk == 1 ]
						then 
							echo $pk

							mydata[$counter]=$val

							let counter=$counter+1
						else echo Primary key exist, please try again with uniqe new value
							counter=$counter
						fi
					else
						echo Invalid input, please try again
						counter=$counter
					fi
				fi
			else
				echo "Please enter $dt data type value to column $((counter+1)) ( $col )"
				read val
				if [ $dt == "int" ]
				then
					if int_check $val;
					then
						mydata[$counter]=$val

						let counter=$counter+1
					else
						echo Invaild input data type, please try again
						counter=$counter
					fi
				else
					if input_check $val;
					then
						mydata[$counter]=$val

						let counter=$counter+1
					else
						counter=$counter
					fi
				fi
			fi

		done




		column_row_values=""
		counter=0
		while [ $counter -lt $numberofcolumn ]
		do

			column_row_values=$column_row_values""${mydata[$counter]}"|"
			let counter=$counter+1

		done


		echo "$column_row_values">>$tablename

		echo "Insertion into $tablename done successfully"


		table_screen
	fi
}
# delete from table
delete_from_table () {
	line
	echo Please enter table name:
	read table

	if input_check $table;
	then
		if [[ -f $table ]]
		then
			echo Please insert the primary key value where the record will be deleted
			read pk
			if [[ $pk != "" ]]
			then
				sed -i -r "/^$pk/d" $table
				echo Record deleted successfully
				table_screen
			else
				echo "Nothing was inserted"
				delete_from_table
			fi

		else
			echo "Table $table doesn't exist"
			delete_from_table
		fi
	else
		echo Invaild input, please try again
		delete_from_table
	fi
}

# drop table
drop_table () {
	line
	echo Please enter table name:
	read table
	if input_check $table
	then 
		if [[ -f $table ]]
		then
			select c in "Are you sure you want to drop table $table ? Type 1 for YES 2 for NO" 
			do
				case $REPLY in
					1) rm $table
						echo $table was dropped successfully
						table_screen
						;;
					2) table_screen;;
					*) echo Sorry invaild select,try again
						drop_table
						;;
				esac
			done

		else 
			echo "Table $table doesn't exist"
			line
			drop_table
		fi
	else 
		echo Invaild input, please try againe
		drop_table
	fi
}


# select from table
select_table () {
	line
	echo Please enter table name:
	read table
	if input_check $table;
	then
		if [[ -f $table ]]
		then
			head=$(awk  'BEGIN{FS="|";}{if (NR==3) print $0}' metadata/metadata_$table |column -t -s"|")
			select c in "Type 1 Select all table" "Type 2 Select a record" "Type r to return or e to exit"
			do
				case $REPLY in
					1) echo --------------------
						echo $head
						echo --------------------
						awk 'BEGIN{FS="|";} {print $0}' $table |column -t -s"|"
						echo "Type r to return or e to exit"

						;;
					2) echo please insert the value of primary key
						read pk
						if [[ $pk != "" ]]
						then
							echo --------------------
							echo $head
							echo -------------------
							awk 'BEGIN{FS="|";} {print $0}' $table|grep ^$pk |column -t -s"|"
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
						select_table
						;;
				esac
			done
		else
			echo "Table $table doesn't exist"
			select_table
		fi
	else
		echo Invaild input, please try again
		table_screen
	fi
}

#////list tables //////

function list_all_tables {
	line
	ls -p |grep -v /
	table_screen
}

function update_table {

	line
	echo "Please enter table name :"
	read tablename
	if input_check $table;
	then

		if ! [[ -f $tablename ]]
		then
			echo "Table does not existed, please try again"
			update_table
		else


			select character in "Update all rows" "Update one row""Type r to return or e to exit"
			do

				case $REPLY in

					1)	echo "Please enter old word"
						read vale2
						echo "Please enter new word"
						read vale3
						sed -i -r s/$vale2/$vale3/g $tablename
						echo "Done ......"
						;;
					2)  echo "Please enter row number "
						read vale
						echo "Please enter old word"
						read vale2
						echo "Please enter new word"
						read vale3


						sed -i -r $((vale))s/$vale2/$vale3/  $tablename
						echo "Done ......"

						;;
					"r")table_screen;;
					"e")exit;;
					*) echo "Invaild input, please try again"
						update_table
						;;


					esac
				done



		fi
	else
		echo Invalid input, please try again
		update_table
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
			4) drop_table
				;;
			5) select_table
				;;
			6) delete_from_table
				;;
			7) list_all_tables
				;;
			"r") dbms_screen;;
			"e")exit;;
			*) echo Invalid input, please try again
				table_screen
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
			"e") exit;;
			"r") 	dbms_screen
				;;
			*)if input_check $REPLY;
			then
				if ! [[ -d $REPLY ]]
				then
					mkdir $REPLY
					cd $REPLY; mkdir metadata; chmod +rwx metadata;
					echo Created database $REPLY
					echo Type r to Return or e to Exit
				else
					echo This name exist, please enter a new name

					create_db
				fi
			else echo Inavild input, please try again
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
			"e") exit;;
			"r")    dbms_screen
				;;
			*)if input_check $REPLY;
			then
				if [[ -d $REPLY ]]
				then    
					rm -r $REPLY
					echo  Dropped database $REPLY 
					echo  Type r to Return or e to Exit
				else    
					echo This database does not exist, please enter a database name
					drop_db
				fi
			else echo Invalid input, please try again
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
			"e") exit;;
			"r")  dbms_screen
				;;
			*)if input_check $REPLY;
			then
				if [[ -d $REPLY ]]
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
			else echo Invalid input, please try again
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
	if [ -d ~/dbms ]
	then
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
		else
			mkdir ~/dbms
			db_screen
	fi
}


######## DBMS Calling ##############
dbms_screen () {
	# intro screen
	welcome_intro
	db_screen
}
dbms_screen

