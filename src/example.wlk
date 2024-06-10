class Persona{
	const enfermedades = []
	var temperatura
	var celulas
	var dias = 0
	
	method temperatura() = temperatura
	
	method temperatura(grados){
		temperatura = 45.min( temperatura + grados)	
	}
	
	method celulas() = celulas
	
	method celulas(resta){
		celulas -= resta	
	}
	
	method contraeEnfermedad(enfermedad){
		if (enfermedades.size() <= 5){
			enfermedades.add(enfermedad)
		}
	}
	
	method enfermedadCurada(enfermedad){
		enfermedades.remove(enfermedad)
	}
	
	method enfermedades() = enfermedades
	
	method recibirMedicamento(medicamento){
		enfermedades.forEach({x => x.disminuyenCelulas(medicamento)})
		self.enfermedadCurada(enfermedades.findOrDefault({x => x.celulasAmenazadas() <= 0}, null))
	}
	
	method viveUnDia(){
		dias += 1
		enfermedades.forEach({x => x.causarEfecto(self)})
	}
	
	method dias() = dias
	
	method celulasAmenazadoras() =
		enfermedades.sum({x => 
			if(x.esAgresiva(self)){x.celulasAmenazadas()}
			else{0}
		})
	
	method enfermedadQueAfectaMasCelulas() =
		enfermedades.max({x => x.celulasAmenazadas()})
	
	method estaEnComa()=
		self.temperatura() >= 45 or self.celulas() < 1000000
}

class Enfermedad{
	var celulasAmenazadas
	
	method aumentanCelulas(cantidad){
		celulasAmenazadas += cantidad
	} 
	method disminuyenCelulas(cantidad){
		celulasAmenazadas = 0.max(celulasAmenazadas - cantidad)
	}
	
	method celulasAmenazadas() = celulasAmenazadas
	
	method causarEfecto(persona){ }
	
	method esAgresiva(persona) = true
	
}

class EnfermedadInfecciosa inherits Enfermedad{
	
	override method causarEfecto(persona){
		persona.temperatura(celulasAmenazadas/1000)
	}
	
	method reproducirse(){ self.aumentanCelulas((celulasAmenazadas * 2) /2) }
	 
	override method esAgresiva(persona) = 
		celulasAmenazadas > persona.celulas() * 0.1
	
} 

class EnfermedadAutoinmune inherits Enfermedad{
	
	override method causarEfecto(persona){
		persona.celulas(celulasAmenazadas)
	}
	
	override method esAgresiva(persona) = 
		persona.dias() >= 30
}

class Doctor{
	const cantidadMedicamento
	
	method atenderPaciente(persona){
		persona.recibirMedicamento(cantidadMedicamento * 15)
	}
}