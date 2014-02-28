<?php 

namespace App;
use Zend;

class TamponPDF {
    
    const DEFAULT_FONT_SIZE = 10;
    const DEFAULT_ALPHA_TRANSPARENCY = 0.5;

    private $docOrigine;
    private $setText;
    private $font;
    private $fontSize;
    private $alphaTransparency;
    private $namefile;
    private $fileSize;

    public function __construct(\Zend_Pdf $docOrigine){
        $this->docOrigine = $docOrigine;
        $this->setText(array("Affiché le " . date("d/m/Y")));
        $this->setFont(\Zend_Pdf_Font::fontWithName(\Zend_Pdf_Font::FONT_HELVETICA));
        $this->setFontSize(self::DEFAULT_FONT_SIZE);
        $this->setAlphaTransparency(self::DEFAULT_ALPHA_TRANSPARENCY);
        $this->namefile = 'doc.pdf';
        $this->fileSize = '1024';
    }

    public function setText(array $textLine){
        $this->textLine = $textLine;
    }

    public function setFont(\Zend_Pdf_Resource_Font $font){
        $this->font = $font;    
    }

    public function setFontSize($fontSize){
        $this->fontSize = $fontSize;
    }

    public function setAlphaTransparency($alpha){
        $this->alphaTransparency = $alpha;
    }

    public function getFileAsString(){
        foreach ($this->docOrigine->pages as $page){
            $this->drawTampon($page);
        }
        return $this->docOrigine->render();
    }

    public function render(){
        foreach ($this->docOrigine->pages as $page){
            $this->drawTampon($page);
        }
        $this->sendDocumentToBrowser();
    }

    public function setNameFile($name){
        $this->namefile = $name;
    }

    public function setFileSize($fileSize){
        $this->fileSize = $fileSize;
    }

    private function drawTampon(\Zend_Pdf_Page $page){
        $width  = $page->getWidth();
                $height = $page->getHeight();
                $page->setFont($this->font, $this->fontSize);
                $page->setAlpha($this->alphaTransparency);
                 if($height > 590 && $height < 597 && $width > 840 && $width < 844){
                        $page -> drawRectangle(820 , 200, 770 , 30,
                                        \Zend_Pdf_Page::SHAPE_DRAW_STROKE);
                        $page -> rotate(810,194,-1.575);
                        foreach($this->textLine as $i => $t){
                                $page->drawText($t, 810,194-$i*15 ,'iso-8859-1');
                        }
                        $page -> rotate(825,150,-3.14);
                }else{
                        $page -> drawRectangle($width - 200, $height - 10,$width - 10,$height - 60,
                                        \Zend_Pdf_Page::SHAPE_DRAW_STROKE);
                        foreach($this->textLine as $i => $t){
                                $page->drawText($t, $width - 195, $height - 22 - $i*15 ,'UTF8');
                        }
                }
    }

    private function sendDocumentToBrowser(){
        header('Content-type: application/pdf');
        header("Content-Disposition: attachment; filename=$this->namefile");
        header("Expires: 0");
        header("Cache-Control: must-revalidate, post-check=0,pre-check=0");
        header("Pragma: public");
        echo $this->docOrigine->render();
    }
}
