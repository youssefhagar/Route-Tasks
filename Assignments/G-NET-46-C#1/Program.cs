using System;
using System.Collections.Generic;
using System.Linq;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace CSharpAssignment
{
    class Program
    {
        
        // Class-level field for scope demonstrations
        static int classField = 100;

        static void Main(string[] args)
        {
            Console.WriteLine("╔════════════════════════════════════════════════════════════════════╗");
            Console.WriteLine("║           C# FUNDAMENTALS - ASSIGNMENT WITH ANSWERS                ║");
            Console.WriteLine("║                      20 Questions                                  ║");
            Console.WriteLine("╚════════════════════════════════════════════════════════════════════╝\n");



            #region Question 1: Regions
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 2: REGIONS
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What is the purpose of #region and #endregion directives in C#? 
            //    How do they help in code organization?
            //
            // ══════════════════════════════════════════════════════════════════════

            //Nested Region Example

            Console.WriteLine("\n" + new string('-', 70) + "\n");
            #endregion

            #region Question 2: Variable Declaration - Explicit vs Implicit
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 3: VARIABLE DECLARATION - EXPLICIT VS IMPLICIT
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What is the difference between explicit and implicit variable 
            //    declaration in C#? Provide examples of both.
            //
            // ══════════════════════════════════════════════════════════════════════



            // EXPLICIT DECLARATION 

            // We specifies the type of the variable 
            // ex : int age = 50 ;
            //      string name = "yousef";

            // IMPLICIT DECLARATION 

            // The compiler Dedict the Type of Variable (Note : You must Assign the variable to a Value )
            // We use Key Word =>  Var
            // ex : Var name = "Yousef";
            // ERROR : var name ; 

            #endregion

            #region Question 3: Constants
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 4: CONSTANTS
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Write the syntax for declaring a constant in C#. Why would you use 
            //    a constant instead of a regular variable?
            //
            // ══════════════════════════════════════════════════════════════════════

            // We use CONSTANTS if we don't Want the Value of Varible to Change
            // We Can't Cahnge the value of it  

            // Constant examples
            // const Double PI = 3.14;
            // ERROR : PI = 2.5;

            #endregion

            #region Question 4: Class-level vs Method-level Scope

            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 4: CLASS-LEVEL VS METHOD-LEVEL SCOPE
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Explain the difference between class-level scope and method-level 
            //    scope with examples.
            //
            // ══════════════════════════════════════════════════════════════════════

            // Declaration 

            // CLASS-LEVEL : in the Class ( Not In Any Method )
            //  METHOD-LEVEL : in the Method
            // We Can Use in 
            // CLASS-LEVEL : in Any Loaction in the Class. We Can Use In Any Method
            //  METHOD-LEVEL : in its Own Method only . we Cannot use it in different Method Or outer its own Method 

            #endregion

            #region Question 5: Block-level Scope
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 5: BLOCK-LEVEL SCOPE
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What is block-level scope? Give an example showing a variable that 
            //    is only accessible within a specific block.
            //
            // ══════════════════════════════════════════════════════════════════════

            {
                int age = 50;
                Console.WriteLine(age); //Valid
            }
            // Console.WriteLine(age); //Not Valid

            #endregion

            #region Question 6: Variable Lifetime - Local vs Static
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 6: VARIABLE LIFETIME - LOCAL VS STATIC
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What is variable lifetime? Explain the lifetime of local variables 
            //    vs static variables.
            //
            // ══════════════════════════════════════════════════════════════════════

            // Static: Lives for entire app lifetime
            // Local: Lives until method ends

            #endregion

            #region Question 7: Garbage Collector
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 7: GARBAGE COLLECTOR
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What is the Garbage Collector in C#? How does it affect the 
            //    lifetime of objects?
            //
            // ══════════════════════════════════════════════════════════════════════

            // GARBAGE COLLECTOR : Manage the Heap 
            // Objects : Store in Heap 
            // Permission : GC Delete The Objects That not Referenced 

            #endregion

            #region Question 8: Variable Shadowing
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 8: VARIABLE SHADOWING
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What is variable shadowing in C#? Does C# allow shadowing in 
            //    nested blocks within the same method?
            //
            // ══════════════════════════════════════════════════════════════════════

            // Shadowing occurs when a variable declared in an inner scope has the same name as one in an outer scope

            // Yes ,  C# allow shadowing in nested blocks within the same method?

            #endregion

            #region Question 9: C# Naming Rules
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 9: C# NAMING RULES
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: List five rules that must be followed when naming variables in C#.
            //
            // ══════════════════════════════════════════════════════════════════════

            /*
             * Names must start with a letter or underscore
             * Can contain letters, digits, and underscores
             * Can not Contain Spaces
             * C# is case-sensitive
             * Aviod Keyword (@ When necessary )
             * */

            #endregion

            #region Question 10: Naming Conventions
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 10: NAMING CONVENTIONS
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What naming conventions are recommended for: (a) local variables, 
            //    (b) class names, (c) constants?
            //
            // ══════════════════════════════════════════════════════════════════════

            /*
             * (a) local variables : PascalCase (ex: FirstName) or camelCase (ex: firstName)
             * (b) class names  :    first letter Must be Capital ( EX : class Car )
             * (c) constants :       PascalCase (ex: Pi) 
             * */

            #endregion

            #region Question 11: Error Types
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 11: ERROR TYPES
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Compare and contrast syntax errors, runtime errors, and logical 
            //    errors. Provide an example of each.
            //
            // ══════════════════════════════════════════════════════════════════════


            // syntax errors :
            // بيكون خطأ فى قواعد اللغه
            //Program will not run until fixed
            //  ex :
            //int x = "Yousef"
            //runtime Error :
            //Happen while program is running
            // ex : int x = 10/0;  // Divide by 0 
            // logical Error : 
            // No compiler error, no exception
            // Program runs but wrong result

            #endregion

            #region Question 12: Exception Handling Importance
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 12: EXCEPTION HANDLING IMPORTANCE
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Why is exception handling important in C#? What would happen if 
            //    you don't handle exceptions?
            //
            // ══════════════════════════════════════════════════════════════════════

            // important for :
            // Catch the error and Tell Me where error or what the error

            //if We cannot use it 
            // We Can't find what the problem in the code and take many time to dedict the errors

            #endregion

            #region Question 13: try-catch-finally
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 13: TRY-CATCH-FINALLY
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Write a code example demonstrating try-catch-finally. Explain when 
            //    the finally block executes.
            //
            // ══════════════════════════════════════════════════════════════════════

            //    the finally block executes. : always executes
            try
            {
                int x = 10;
                int y = 0;
                Console.WriteLine(x / y);
            }
            catch (DivideByZeroException ex)
            {
                Console.WriteLine("Cannot divide by zero");
            }
            finally
            {
                Console.WriteLine("Finally block always executes");
            }



            #endregion

            #region Question 14: Common Built-in Exceptions
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 14: COMMON BUILT-IN EXCEPTIONS
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: List and explain five common built-in exceptions in C# with 
            //    scenarios when each would occur.
            //
            // ══════════════════════════════════════════════════════════════════════


            /*
             * NullReferenceException    : Using a member on null object
             * FormatException           : invalid string format when parsing
             * DivideByZeroException     : Dividing an integer by zero 
             * IndexOutOfRangeException  : Accessing invalid array index
             * ArgumentNullException     : Null passed to method parameter
             * ArgumentException         : Invalid argument value
             * FileNotFoundException     : File does not exist
             * nvalidOperationException  : Operation not valid in current state
             * */

            #endregion

            #region Question 15: Multiple catch Blocks
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 15: MULTIPLE CATCH BLOCKS
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Why is the order of catch blocks important when handling multiple 
            //    exceptions? Write code showing correct ordering.
            //
            // ══════════════════════════════════════════════════════════════════════

            // correct Order : 
            //catch (FormatException) { }
            //catch (ArgumentException) { }
            //catch (Exception) { } // Last

            // if We use ( catch (Exception) { } ) At first , After  Exceptions are  unreachable 

            #endregion

            #region Question 16: throw Keyword
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 16: THROW KEYWORD
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: What is the difference between 'throw' and 'throw ex' when 
            //    re-throwing an exception? Which one preserves the stack trace?
            //
            // ══════════════════════════════════════════════════════════════════════

            // throw; Keeps original location
            // throw ex;  Loses original location!

            // Which one preserves the stack trace?
            // is => throw ex

            #endregion

            #region Question 17: Stack and Heap Memory
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 17: STACK AND HEAP MEMORY
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Explain the differences between Stack and Heap memory in C#. 
            //    What types of data are stored in each?
            //
            // ══════════════════════════════════════════════════════════════════════

            // Stack : int , double, struct ,enum , bool
            //Heap   : Objects ,strings , Arrays

            #endregion

            #region Question 18: Value Types vs Reference Types
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 18: VALUE TYPES VS REFERENCE TYPES
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Write a code example showing how value types and reference types 
            //    behave differently when assigned to another variable.
            //
            // ══════════════════════════════════════════════════════════════════════


            // Value Type
            int a = 10;
            int b = a;
            b = 20;

            Console.WriteLine(a); // 10
            Console.WriteLine(b); // 20

            // Reference Type
            int[] arr1 = {1,2,3,4,5,6,7};
            int[] arr2 = arr1;

            arr2[0] = 0;

            Console.WriteLine(arr1[0]);
            Console.WriteLine(arr2[0]);

            #endregion

            #region Question 19: Object in C#
            // ══════════════════════════════════════════════════════════════════════
            // QUESTION 19: OBJECT IN C#
            // ══════════════════════════════════════════════════════════════════════
            //
            // Q: Why is 'object' considered the base type of all types in C#? 
            //    What methods does every type inherit from System.Object?
            //
            // ══════════════════════════════════════════════════════════════════════

            /*
             It is the root type of the C# type hierarchy, and every type, whether primitive (like int, float) 
            or complex (like string, class), is eventually derived from object
             */
            #endregion

        }


    }


}