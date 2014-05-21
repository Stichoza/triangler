    $.fn.triangler = function (options) {

        var settings = $.extend({
            color: "#00ff00",
            colorDistort: 0.75,
            width: 500,
            height: 500,
            size: 50,
            shadeMin: -70,
            shadeMax: 70,
            distort: 40,
            forceEdges: true
        }, options);

        var shadeRGBColor = function (color, percent) {
            var num = parseInt(color.slice(1), 16),
                amt = Math.round(2.55 * percent),
                R = (num >> 16) + amt,
                G = (num >> 8 & 0x00FF) + amt,
                B = (num & 0x0000FF) + amt;
            return "#" + (0x1000000 + (R < 255 ? R < 1 ? 0 : R : 255) * 0x10000 + (G < 255 ? G < 1 ? 0 : G : 255) * 0x100 + (B < 255 ? B < 1 ? 0 : B : 255)).toString(16).slice(1);
        };

        var getColor = function (i, j, countX, countY) {
            //var percent = Math.round(Math.random() * (settings.shadeMax - settings.shadeMin) + settings.shadeMin) * (Math.random() - 0.5) * ((i + j) / 2);
            var percent = (200 * (i + j)) / (countX + countY) - 50;
            percent *= Math.random() * settings.colorDistort;
            percent = -percent;
            return shadeRGBColor(settings.color, percent);
        };

        var graph = {
            nodes: [],
            edges: []
        };

        this.html('');
        
        var canvas = $('<canvas></canvas>')
            .attr('height', settings.height)
            .attr('width', settings.width)
            .appendTo(this)[0];

        if (!canvas.getContext) {
            console.error('Cannot get canvas context');
            return false;
        }
        
        
        var countX = Math.ceil((settings.width + settings.distort) / settings.size);
        var countY = Math.ceil((settings.height + settings.distort) / settings.size);
        
        
        var randomX;
        var randomY;
        
        for (var i = 0; i < countX+1; i++) {
            graph.nodes[i] = [];
            for (var j = 0; j < countY+1; j++) {
                randomX = (i == 0 || i == countX-1) ? 0 : Math.random();
                randomY = (j == 0 || j == countY-1) ? 0: Math.random();
                graph.nodes[i].push([
                    settings.size * i + Math.random() * settings.distort * randomX,
                    settings.size * j + Math.random() * settings.distort * randomY]);
            }
        }

        console.log(graph);

        var ctx = canvas.getContext('2d');

        for (var i = 0; i < countX; i++) {
            for (var j = 0; j < countY; j++) {
                for (var k = 0; k < 2; k++) {
                    //if (k==0) continue;
                    ctx.fillStyle = ctx.strokeStyle = getColor(i, j, countX, countY);
                    ctx.beginPath();
                    ctx.moveTo(graph.nodes[i][j][0], graph.nodes[i][j][1]);
                    ctx.lineTo(graph.nodes[i + k][j + 1 - k][0], graph.nodes[i + k][j + 1 - k][1]);
                    ctx.lineTo(graph.nodes[i + 1][j + 1][0], graph.nodes[i + 1][j + 1][1]);
                    ctx.closePath();
                    ctx.stroke();
                    ctx.fill();
                }
                //return;
            }
        }

        // Apply styles
        this.css({
            overflow: 'hidden'
        });
        console.log('Generating ' + countX + 'x' + countY + ' grid');

        return this; // Method chaining
    };
