package antlr;

/**
 * <b>SOFTWARE RIGHTS</b>
 * <p>
 * ANTLR 2.5.0 MageLang Institute, 1998
 * <p>
 * We reserve no legal rights to the ANTLR--it is fully in the
 * public domain. An individual or company may do whatever
 * they wish with source code distributed with ANTLR or the
 * code generated by ANTLR, including the incorporation of
 * ANTLR, or its output, into commerical software.
 * <p>
 * We encourage users to develop software with ANTLR. However,
 * we do ask that credit is given to us for developing
 * ANTLR. By "credit", we mean that if you use ANTLR or
 * incorporate any source code into one of your programs
 * (commercial product, research project, or otherwise) that
 * you acknowledge this fact somewhere in the documentation,
 * research report, etc... If you like ANTLR and have
 * developed a nice tool with the output, please mention that
 * you developed it using ANTLR. In addition, we ask that the
 * headers remain intact in our source code. As long as these
 * guidelines are kept, we expect to continue enhancing this
 * system and expect to make other tools available as they are
 * completed.
 * <p>
 * The ANTLR gang:
 * @version ANTLR 2.5.0 MageLang Institute, 1998
 * @author Terence Parr, <a href=http://www.MageLang.com>MageLang Institute</a>
 * @author <br>John Lilley, <a href=http://www.Empathy.com>Empathy Software</a>
 * @author <br><a href="mailto:pete@yamuna.demon.co.uk">Pete Wells</a>
 */
class ObjcBlockFinishingInfo {
	String postscript;		// what to generate to terminate block
	boolean generatedSwitch;// did block finish with "default:" of switch?
	boolean generatedAnIf;

	/** When generating an if or switch, end-of-token lookahead sets
	 *  will become the else or default clause, don't generate an
	 *  error clause in this case.
	 */
	boolean needAnErrorClause;


	public ObjcBlockFinishingInfo() {
		postscript=null;
		generatedSwitch=false;
		needAnErrorClause = true;
	}
	public ObjcBlockFinishingInfo(String ps, boolean genS, boolean generatedAnIf, boolean n) {
		postscript = ps;
		generatedSwitch = genS;
		this.generatedAnIf = generatedAnIf;
		needAnErrorClause = n;
	}
}
